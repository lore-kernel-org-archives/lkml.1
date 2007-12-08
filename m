Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbXLHTwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbXLHTwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbXLHTwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:52:06 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:22275 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXLHTwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:52:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kwg79Z9R1CGpSwzHNWCQlq7lEUaVd0675JWkKDCL3frmoIPX0/vDqBxfBFsEKjX1grXNNwNdd5LPeAWkw05GPg1GhV6MoiB5RuxD9tpSPcdWiVPJ2GwflVGWQ4gv+FoRsuhchGMUA1/9qu+IVFc2g21+/wwHCxyZOKPxHpqyoLA=
Message-ID: <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>
Date: Sat, 8 Dec 2007 20:52:01 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Peter Zijlstra" <peterz@infradead.org>,
       "Daniel Walker" <dwalker@mvista.com>
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Dave Chinner" <dgc@sgi.com>
In-Reply-To: <1197135413.6353.36.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
	 <1197133910.6353.33.camel@lappy>
	 <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>
	 <1197135413.6353.36.camel@lappy>
X-Google-Sender-Auth: 014cd7a8cdb64175
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter and Daniel,

> Yeah, it are different lock instances, however by virtue of sharing the
> same lock init site, they belong to the same lock class. Lockdep works
> by tracking class dependancies, not instance dependancies.

The device and its parent both indeed have different
pointers/instances. I saw that during debugging yesterday, so I
already expected this was not really a bug, but a false positive of
lockdep.

> By generalizing to classes it can detect locking errors before they
> actually occur.

Basically that is a good thing...
But... now we do not transfer the dev->sem to a mutex, because lockdep
will start generating false positives, and thus we mask the lockdep
error, by not converting the dev->sem to what it really is...

This does give me a bad feeling about this...  In short, we are
implementing workarounds in good code code to hide bugs in
debug-tooling... ?!

So, any suggestions on how to fix lockdep? Anyone some good hints
where I can start?
Is it that fundamental to lockdep that it cannot be fixed without
breaking it, or do we have to instrument the code that tells lockdep
to ignore this particular mutex?


Kind Regards,

Remy
