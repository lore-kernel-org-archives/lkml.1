Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbXGWWK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbXGWWK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXGWWKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:10:48 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:22565 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXGWWKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:10:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cSN3nYoISsUprkg5P3B8T1Josg6qcNkkJl8BGQAFd8KBJs4Y7BssV7EX8avVTWy3ruH6Fs2XpFVULrwLrqw/bb7fwk+2K/1P75+khRudZ7/7yTbWXyOUUKPevXUGMOqgcX/v9PVmP/EgI+PKtgPgsgCNEHT1MKE91PVJQSF0+Nw=
Message-ID: <8bd0f97a0707231510j52c209e2vf09b023be6e47b1c@mail.gmail.com>
Date: Mon, 23 Jul 2007 18:10:46 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: early_printk accessing __log_buf
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
In-Reply-To: <20070723140541.8fac78c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	 <200707182358.24984.rgetz@blackfin.uclinux.org>
	 <8bd0f97a0707221650r3bab822fq2d457d19eba1c8eb@mail.gmail.com>
	 <200707231419.13182.rgetz@blackfin.uclinux.org>
	 <20070723131553.2943861f.akpm@linux-foundation.org>
	 <8bd0f97a0707231354k7732f647qc0b55f105440ca1c@mail.gmail.com>
	 <20070723140541.8fac78c5.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 23 Jul 2007 16:54:36 -0400
> "Mike Frysinger" <vapier.adi@gmail.com> wrote:
>
> > On 7/23/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Mon, 23 Jul 2007 14:19:12 -0400
> > > Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > >
> > > > On Sun 22 Jul 2007 19:50, Mike Frysinger pondered:
> > > > >
> > > > > i think the attached two functions account for what Robin and Andrew
> > > > > were thinking ...
> > > >
> > > > A note about why/when grab_lock would be set to zero (pre-kernel init, or
> > > > OOPs) might be nice.
> > >
> > > Definitely.
> > >
> > > The pre-kernel init shouldn't be an issue: logbuf_lock is initialised at
> > > compile time.
> > >
> > > At oops time we could possibly use oops_in_progress to work out whether to
> > > avoid taking the lock.  That's not terribly nice, but nor is it nice for
> > > callers to know about printk internals.
> >
> > maybe, but for early debug users (the reason we wanted this
> > originally), it wouldnt be an oops in progress ... but i guess we can
> > just as easily set oops_in_progress to 1 in our code before calling
> > this function to keep from having to worry over locks from being
> > doubly grabbed.
>
> I don't immediately see how logbuf_lock could be doubly grabbed.  Only if
> you're calling this from hard irq context?

i guess i'm just assuming the worse here and making sure that
something i couldnt conjure up doesnt have the opportunity to bite me
in the ass.  doubly grabbed, memory corruption, whatever ... i dont
really have a real scenario as i dont have a very active imagination
;)
-mike
