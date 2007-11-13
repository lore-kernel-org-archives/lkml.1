Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXKMQDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXKMQDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbXKMQC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:02:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:40131 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbXKMQC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:02:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HhE2wqjcwHAr3AZZWqbZl2Ebim8vF0Mg6gfdMoRixHR3O8k+Ozh2VLXMRUY3jUdrHLN8XpPa8OXSPHgdqxS8frAcalDEAQ2aDB6s13cU9X1lPqOumNdWANew+cdM0vdqUwuKk4WqTtNbY+K6B7/UVufQduyBv3xJeaP0GuE05IU=
Message-ID: <b647ffbd0711130802g2f1e9659kd73756538e15ce09@mail.gmail.com>
Date: Tue, 13 Nov 2007 17:02:56 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Florian Boelstler" <kernel@boelstler.net>
Subject: Re: Strange delays / what usually happens every 10 min?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <fhcc39$51b$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fhcc39$51b$1@ger.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/2007, Florian Boelstler <kernel@boelstler.net> wrote:
> Hi,
>
> this issue has been already discussed on the kernelnewbies mailing list
> [1],[2] and suggested to be further discussed here.
>
> I am currently working on a MPC8540-based custom board, which runs Linux
> 2.6.15 (arch/ppc). The original Linux sources have been modified to
> support that custom board. (Additional patches to support LTT are
> applied as well, though disabled in the running kernel)
>
> I set up a periodically running kernel thread, which is delayed for a
> single jiffy using schedule_timeout() in an infinite loop. It is used to
> measure delays between invocations of that thread. For measuring the
> distance in time the PPC's time base lower half register is used
> (obtained using get_cycles() defined in asm/timex.h).
>
> The thread calculates the delay to the previous run and only outputs the
> result if a new maximum value has been determined (in respect to all
> previous cycles). Further the thread outputs a warning if a very "high"
> delay was determined. I.e. a delay greater than 5ms.
>
> While running that test driver a delay of about 10ms _exactly_ occurs
> every 10 minutes.
> And now the funny part starts.
> I got a response from Bruce Rowen on kernelnewbies, telling me that he
> came across the same problem. He increased his AMD-Geode-based platform
> to 1GB of RAM (256MB before) and also hit the 10-minutes-issue a few
> month ago (using Linux 2.6.13).
> Going back to 256MB cured the problem. I did the same thing by
> instructing the boot loader in order to only use 256 MB of RAM (instead
> of 512MB) and yes, the 10-minutes-issue was gone as well.

Not necessarily gone. I'd say, the question is not whether you still
have 'delays' (> 5 ms. in your case) once in a fixed interval (10
minutes) but whether you have noticeable blips, which are significant
wrt maximum 'delays' you otherwise observe between those points of
time.

What are maximum 'delays' you see before hitting this "once in 10
minutes" point?

say, with 256 Mb. the blips could just become lower (e.g. 2 ms.) and
are not reported as "big ones" (>5 ms. in your terms)...

Quite often the source of high periodic latency is SMI (System
Management Interrupts)... I don't know though, whether any of SMI
activities are somehow dependent on the size of RAM.


-- 
Best regards,
Dmitry Adamushko
