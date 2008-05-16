Return-Path: <linux-kernel-owner+w=401wt.eu-S1760962AbYEPU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962AbYEPU3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbYEPU3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:29:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57935 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbYEPU3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:29:30 -0400
Message-ID: <482DEDA5.9080309@zytor.com>
Date: Fri, 16 May 2008 13:25:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org,
       Jeff Garzik <jeff@garzik.org>, Herbert Xu <herbert@gondor.apana.org.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
References: <482C8595.5030509@garzik.org>	 <200805160943.08788.rusty@rustcorp.com.au>	 <200805161531.44725.rusty@rustcorp.com.au>	 <200805161539.59739.rusty@rustcorp.com.au> <1210934981.6381.1.camel@johannes.berg>
In-Reply-To: <1210934981.6381.1.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Berg wrote:
>> +
>> +/* Our random number generator device reads from /dev/urandom into the Guest's
>> + * input buffers.  The usual case is that the Guest doesn't want random numbers
>> + * and so has no buffers although /dev/urandom is still readable, whereas
>> + * console is the reverse.
> 
> Is it really a good idea to use the hosts /dev/urandom to fill the
> guests /dev/random?

Only if you have an entropy estimate to go with it.  It's still dubious, 
though: the guests own pool will do its own mixing, so you might as well 
pull from /dev/random in the host as being a genuine entropy source and 
only add what entropy is available.

	-hpa
