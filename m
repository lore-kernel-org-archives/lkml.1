Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbYCAAml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbYCAAml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 19:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761023AbYCAAmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 19:42:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:54818 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759047AbYCAAmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 19:42:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I3dxTGXzD/cENmmoaVGYGX+tU7njmTvkEHW2qeJ8a8/GWNnIINdzIS7hM1aUjMr8uIRvV8jJ3INQq3lkPZeJACDrgYCllEMsWCfxG0TeMWv8EJdqCN8AlfEisOgC9r5VZhJnKg6hbokxFT05ER6n8/mF+oNeQkIl3EP5Ykh82Do=
Message-ID: <f19298770802291642v56a8a50ve5c7c88de53513f4@mail.gmail.com>
Date: Sat, 1 Mar 2008 03:42:17 +0300
From: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: printk timestamps jumping back and forth in 2.6.25-rc.
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@linux.intel.com>
In-Reply-To: <20080229194547.GC21249@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f19298770802280626g5ee17328ldedf7658a9f26f56@mail.gmail.com>
	 <20080228201315.GA30736@elte.hu> <20080228201613.GA30999@elte.hu>
	 <f19298770802281324v1fc37cf4oebd680b81d0e0a2f@mail.gmail.com>
	 <20080229194547.GC21249@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 10:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
>
>
>
> > On Thu, Feb 28, 2008 at 11:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  > >
>  > >  * Ingo Molnar <mingo@elte.hu> wrote:
>  > >
>  > >  > > Anything else I can do?
>  > >  >
>  > >  > yes, please test the patch below - does it fix the problem?
>  >
>  > The patch worked well, thanks
>  >
>  > I still observe some uneven mouse behaviour during compilations (linux
>  > kernel, make -j 6), like, when I slowly move the mouse, it would stop
>  > for a split of a second every few seconds (the intervals are not
>  > equal). On 2.6.23/24 it works very smooth. Of course, I can't say that
>  > the scheduler is to be blamed. It was only my assumption because I
>  > thought I might be confused by the non-monotinic time, which I see is
>  > not the case. Any ideas, how to debug this?
>
>  could you try latencytop, what does it say, what type of scheduler (and
>  other) delays are there?
>

I'm not sure I fully understand how to use this tool.
There are clearly two possible options to the utility,
--unknown and -d, but I still have no idea what they do..

Does the latencytop-0.3 actually work? I my case the upper half of the
window is always empty. The lower half shows always one line, like

Scheduler: waiting for cpu \t \t \t \t $some_val $some_val

The two values are always identical.

In the 2.6.24 case, the values for Xorg are always around 20 ms
when a make -j 6 is runig in parallel. For the 2.6.25 the
values jump from 100 ms to over 1000 ms.

Later I mounted a tmpfs and run the compilation (from root) there
(swap turned off). This time the Xorg latency was usually less then
30 ms, but the gnome-terminal (running from an other user) was not
that lucky with latencies around 500-1000 ms. Now I ran the same compilation
from user, and the latencies came back to what I observed before, with
gnome-terminal being about 30-50 and Xorg jumping from 100 to now
over 2000. The latencytop and some daemons runnig as different users
also had comparable latencyes.

Yes, fair group scheduler enabled, the config can be seen here:
http://romomatic.osuosl.org/share/xl0/config-2.6.25-rc3

I"ll now recompile with fair group scheduler disabled, just to be sure.
