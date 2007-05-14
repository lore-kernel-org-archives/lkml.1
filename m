Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbXENMeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbXENMeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXENMeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 08:34:18 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:44182 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751153AbXENMeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 08:34:17 -0400
Message-ID: <4648552D.3060808@aitel.hist.no>
Date: Mon, 14 May 2007 14:25:17 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Learning Linux <learninglinux4@gmail.com>
CC: kernelnewbies@nl.linux.org, linux-newbie@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Why can't we sleep in an ISR?
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
In-Reply-To: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Learning Linux wrote:
> I have a very basic doubt here ... what makes it impossible to sleep
> in an ISR? I mean, I know that the kernel preemption is disabled and
> the kernel will panic, but I could not understand why?
First: an ISR is meant to be very quick. It is supposed to do only a
minimum of work needed to service the interrupt, then exit.
This is important, as other interrupts might be blocked during your ISR.
Sleeping is out of question, even a long-running loop in no-no.

Second: You don't ever need to sleep in an ISR anyway.
Complicated work that might take time or might need to sleep
is not supposed to be in an ISR.  If you think you have a need,
tell us what you're up to and hopefully someone will explain
how do do things properly.

When an interrupt happens that needs complicated servicing, the
ISR don't do the whole job.  It just acknowledges the interrupt,
perhaps does a few things with the device in question, then it
exits. It leaves the rest of the work for a bottom half or kernel
thread or something like that.  Kernel threads may sleep . . .

Helge Hafting
