Return-Path: <linux-kernel-owner+w=401wt.eu-S1758157AbXELUUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157AbXELUUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXELUUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:20:05 -0400
Received: from www.osadl.org ([213.239.205.134]:38875 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756637AbXELUUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:20:03 -0400
Subject: Re: clockevent questions
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <38b2ab8a0705121313k37be467cy55402b490101ac9c@mail.gmail.com>
References: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
	 <1178982892.22481.183.camel@localhost.localdomain>
	 <38b2ab8a0705121313k37be467cy55402b490101ac9c@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 12 May 2007 22:23:11 +0200
Message-Id: <1179001391.22481.216.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 22:13 +0200, Francis Moreau wrote:
> > Yes, it is correct. The generic timer code requests an event in the
> > future. It does not care, whether the hardware device can handle that or
> > not. So the clock event code limits the delta to the maximum delta the
> > device can handle. The interrupt fires and the generic timer code
> > reschedules the event with the remaining delta time.
> >
> 
> Thanks again for explanations. Could you give me a pointer of this reschedules ?

Well, it ends up in hrtimer_interrupt() and the code there finds out,
that the next timer is not due right now, so it simply requests the same
(absolute) time event again, which is processed by the clock events code
and eventually limited to the max delta of the device again.

	tglx


