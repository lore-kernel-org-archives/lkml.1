Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbXDIJUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbXDIJUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 05:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXDIJUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 05:20:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:6309 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXDIJUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 05:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ptoRiPue7sqy4nSs/UsUYkYn3JVk/1pxsOGgVEsnQKI/8U7U3l62ZVkN0Gd9uW6LtrFERPRv8yHcuYZPgeL6aIVJXFGaMMqgG8uDUBxQaZInhAlWX50gGFGevUPjv5R5dxQseHeOkPL+uuPiDAJnk0Ej6HUWaLSvuK0gKwioqyk=
Message-ID: <b647ffbd0704090220p60c49ec9w8eb1083943526155@mail.gmail.com>
Date: Mon, 9 Apr 2007 11:20:16 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Mike Galbraith" <efault@gmx.de>
Subject: Re: SD scheduler testing hitch
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1176099797.6355.122.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704082134.43029.a1426z@gawab.com>
	 <1176099797.6355.122.camel@Homer.simpson.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/07, Mike Galbraith <efault@gmx.de> wrote:
> On Sun, 2007-04-08 at 21:34 +0300, Al Boldi wrote:
> > Mike Galbraith wrote:
> > > On Sat, 2007-04-07 at 19:17 +0200, Mike Galbraith wrote:
> > > > I lowered the time to 500us, and ran at nice -10.. it starves tenpercent
> > > > here every time.  (ran as taskset -c 1 nice -n -10 ./fairtest)  The
> > > > starving 10% duty cycle task has trouble getting 1% CPU.
> > >
> > > Hmm.  Playing with it some more today, it still happens, but it's not
> > > very repeatable.  Something is odd.  I wonder if any SD using readers
> > > will try it.
> >
> > Tried it on mainline 2.6.20.3.
> > It's not easily repeatable, but it's got the same problem.

In my case, it's easily reproducible. Below is a mainline 2.6.19.

Look at both %CPU and TIME+ (sched_time).

top - 10:55:00 up 33 min,  8 users,  load average: 1.07, 0.61, 0.51
Tasks:  76 total,   2 running,  74 sleeping,   0 stopped,   0 zombie
Cpu(s): 76.0% us,  0.3% sy,  0.0% ni, 23.7% id,  0.0% wa,  0.0% hi,  0.0% si
Mem:    256592k total,   251888k used,     4704k free,    46516k buffers
Swap:   272120k total,     4924k used,   267196k free,    90048k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 8113 dimm      15   0  1460  436  360 R 74.4  0.2   1:43.63 fairtest_xx
 8114 dimm      15   0  1460  108   32 S  0.3  0.0   0:00.15 fairtest_xx


If you take a look at my previous report, you'll also notice
"strangeness" with both cpu% and sched_time.

sched_clock() is based on "tsc" and it's available for my CPU. So
maybe something fishy is going on with accounting.

I just wonder, why it's so easily reproducible in my case for both
mainline and SD (besides a 2.6.13 mainline, but I have to re-run all
the tests letting tenp run longer for the "sched_time" to be
accumulated)...

-- 
Best regards,
Dmitry Adamushko
