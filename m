Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXEEUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXEEUqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933463AbXEEUqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:46:16 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:27813 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455AbXEEUqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:46:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=aIpDH+7mCsratYWu9UA6S8w3ojG9hImgVVnhNoN1tFhV7ioW4Sqe0DlUBPX7RvQ4qx9CSyvTSC2TP39pQV9dFe1PUxl6qbvzg4HIKOI548NCACF7OUX58eYNVzIcrCuH+a9BOC3Wqr2IKCUzx0HxLEnS5ZDaLX+0Xv42dIFNc98=
Message-ID: <2c0942db0705051346jabd14bam170cf4cf8b54d473@mail.gmail.com>
Date: Sat, 5 May 2007 13:46:14 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFT][PATCH] swsusp: Change code ordering related to ACPI
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Marcus Better" <marcus@better.se>, "Pavel Machek" <pavel@ucw.cz>,
       "Tobias Diedrich" <ranma+kernel@tdiedrich.de>,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200705051150.22108.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705041143.02451.rjw@sisk.pl>
	 <2c0942db0705041611u2d82fbb7m4719c1bcf8bcdbf7@mail.gmail.com>
	 <200705051150.22108.rjw@sisk.pl>
X-Google-Sender-Auth: 2436f7521b380d10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/5/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, 5 May 2007 01:11, Ray Lee wrote:
> > On 5/4/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > The change of the hibernation/suspend code ordering made before 2.6.21 has
> > > caused some systems to have problems related to ACPI.  In particular, the
> > > 'platform' hibernation mode doesn't work any more on some systems.
> >
> > It seems that somewhere between 2.6.21-rc4 and 2.6.21 final my laptop
> > stopped being able to come out of suspend to RAM. Before I start
> > bisecting (again, sigh), is this ringing any bells for anyone? In
> > particular your, patch (snipped) that deals with hibernation, would it
> > also affect suspend to RAM?
>
> Not this particular one, but you may try to move pm_finish() after
> resume_console() in kernel/power/main.c:suspend_prepare() and see if that
> helps.
>
> If it doesn't help, then try to compile the kernel with NO_HZ and
> HIGH_RES_TIMERS unset.  If that doesn't help, you may try with HPET_TIMER
> unset additionally.

Okay, my system is doing it with a known good kernel as well
(2.6.21-rc4), so this is something else. Please ignore my report for
now. In the meantime, I'll be downgrading my hal and drm to what they
were a week ago to see if that fixes the problem.

(I knew better than to change more than one thing at a time, really I
did. Sigh.)

Thanks for your help regardless,

Ray
