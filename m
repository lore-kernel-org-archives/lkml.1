Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbXEMFxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbXEMFxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 01:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbXEMFw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 01:52:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:29570 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbXEMFwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 01:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HinG4m+tV60H0QV4IydcSa6ZYqKzAjCXpIlVrz4xs32Y59iVaPzB5vZ5M/vllC8wA6A+nO9t6TL3NuNQEdbVV096ORYJfjmBcW51OsQgm8et34Qnz3RWUAW4aXJreSDO3uYei8yj1pFdyVyGlq1BPYaHBsLzrhrP/Ok9o7ZbrOI=
Message-ID: <38b2ab8a0705122252kc067722s3298db20cfd5552a@mail.gmail.com>
Date: Sun, 13 May 2007 07:52:54 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: tglx@linutronix.de
Subject: Re: clockevent questions
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1179001391.22481.216.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
	 <1178982892.22481.183.camel@localhost.localdomain>
	 <38b2ab8a0705121313k37be467cy55402b490101ac9c@mail.gmail.com>
	 <1179001391.22481.216.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sat, 2007-05-12 at 22:13 +0200, Francis Moreau wrote:
> > > Yes, it is correct. The generic timer code requests an event in the
> > > future. It does not care, whether the hardware device can handle that or
> > > not. So the clock event code limits the delta to the maximum delta the
> > > device can handle. The interrupt fires and the generic timer code
> > > reschedules the event with the remaining delta time.
> > >
> >
> > Thanks again for explanations. Could you give me a pointer of this reschedules ?
>
> Well, it ends up in hrtimer_interrupt() and the code there finds out,
> that the next timer is not due right now, so it simply requests the same
> (absolute) time event again, which is processed by the clock events code
> and eventually limited to the max delta of the device again.
>

OK, I'll give it a deeper look soon.

Thanks for your great work !
-- 
Francis
