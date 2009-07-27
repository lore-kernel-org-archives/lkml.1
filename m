Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZG0SQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZG0SQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZG0SQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:16:28 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43535 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZG0SQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:16:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JECTeT1V40GQ6jQGsWIrUc3oHV5ZeMXoWQsWmG9mSuP65wK6u4BNkUplV6u1VmrkK
	gE+Gfbt0rg2uuIuQ8UFvw==
Date: Mon, 27 Jul 2009 11:16:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <alpine.DEB.1.10.0907271320130.13513@gentwo.org>
Message-ID: <alpine.DEB.2.00.0907271113460.8408@chino.kir.corp.google.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net> <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com> <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com>
 <alpine.DEB.2.00.0907270227420.15760@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271320130.13513@gentwo.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, Christoph Lameter wrote:

> On Mon, 27 Jul 2009, David Rientjes wrote:
> 
> > We need DEBUG_FLAGS to determine which flags to mask off to reduce the
> > minimum order, so I don't see DEBUG_FLAGS_SIZE as troublesome.
> >
> > Christoph?
> 
> Post a patch? Otherwise just go ahead.
> 
> 

My patch is already in Pekka's slab-2.6.git tree at 
http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commit;h=fa5ec8a1f66f3c2a3af723abcf8085509c9ee682

You had proposed http://marc.info/?l=linux-kernel&m=124725166205814, which 
moves the mask to kmem_cache_open() and calls calculate_sizes() twice.  
That eliminates DEBUG_FLAGS_SIZE, but I don't see that define as being 
troublesome since we must define DEBUG_FLAGS to specify what options add 
metdata anyway.
