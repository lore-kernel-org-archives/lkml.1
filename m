Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbXF3VyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbXF3VyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 17:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXF3VyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 17:54:08 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:57932 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbXF3VyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 17:54:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jJaTuusvVj57MFRoiph9oPFz4xFfNUPjIh7lJ+NDeMv9E+K99IZeWZA5ouoaH/Sdx3nPtvMrNfEvlAYfos0PWlfDmQsnaSleCxcvobdhaQotEgcv8yurhSQJCOtT7ZnW2zmhSgakgSxPc7yL1XYUXSytSkcKtntnoVSQxQtyD3s=
Message-ID: <a36005b50706301454j46c23760m5f0ac6088fe24a9d@mail.gmail.com>
Date: Sat, 30 Jun 2007 14:54:06 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0>
	 <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com>
	 <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> But, a __get_user(), once you scrap off all the gcc wrapping, is bacially
> a move. That could even be removed, but really I don't see the reason
> since it allows for a cleaner strcture definition in userland.

Don't generalize.  The 4G/4G kernel, for instance, doesn't have this
property.  Who knows what else will come up.  Anyway, two memcpy are
slower than one.


> But this does not allow more than one context to be set at a time, like
> the current implementation does. Ie, the current implementation allow you
> to:

Of course it does.  It just requires an appropriate union element.
I've listed flags and sigset_t as separate union elements since I
cannot think of a place where we need both extensions.  Should there
be one this can easily be changed.
