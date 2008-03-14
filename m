Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYCNR3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYCNR3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYCNR3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:29:44 -0400
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:51968 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754101AbYCNR3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:29:40 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Justin Madru <jdm64@gawab.com>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
Date: Fri, 14 Mar 2008 10:29:38 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
References: <47D828BB.2000702@gawab.com> <200803131009.01889.jbarnes@virtuousgeek.org> <47D9FD71.5080909@gawab.com>
In-Reply-To: <47D9FD71.5080909@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803141029.38124.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 13, 2008 9:22 pm Justin Madru wrote:
> Jesse Barnes wrote:
> > Well, the blank screen is probably due to a pipe programming timing
> > problem. IGD devices have been getting less & less sensitive to it over
> > time (830s would hang if you looked at them the wrong way) but it's still
> > not that hard to mis-program them.
> >
> > Can you narrow down the problem at all?  Did it occur just after a kernel
> > upgrade?  Or did you also upgrade your X driver?  There haven't been any
> > real changes in intelfb since Oct. when Krzysztof added interlaced mode
> > support, so it's weird that you're just seeing problems now...
>
> Not that I can think of. Other than a custom kernel I use standard
> Ubuntu 7.10. I was testing out the kernel starting with 2.6.23-rc4 and
> I've tested each rc, recompiling when a new one came out (except for rc1
> and rc2, they didn't compile). So, when 2.6.25-rc3 came out I recompiled
> and came across this error.

It would be interesting if you could get register dumps at a couple of 
different points, using the intel_reg_dumper tool in 
git://git.freedesktop.org/git/xorg/driver/xf86-video-intel (in 
src/reg_dumper).  You'll probably have to modify your boot scripts though.  
It would be good to get them:
  - at startup time before the splash screen
  - sometime while the splash screen is running
  - after X starts and you see the blank screen

Since I think this is actually an X driver bug, can you file a bug at 
freedesktop.org and attach the register dumps there?

>
> I've removed all fb devices and the blank screen _almost_ never happens
> (also, I _don't_ have to disable the splash screen). There is one
> _big_exception_ the problem still happens when I'm at my University (and
> _very_ consistently). There, I have to disable the splash screen, and
> that ~mostly~ fixes the problem.

What's different between your Uni. environment and your home environment?

> I can't believe it could be related, but when I boot the computer at the
> Univ. I get a flood of kernel messages  related to the wireless all the
>
> time, but still connect:
>  > kernel: wlan0_rename: RX too short data frame payload
>
> _Could_ a wireless problem be related to a graphics's problem? I
> wouldn't think so? But, it would explain why I get the blank screen
> mostly when I get the wireless problem. But, then again it could be
> another problem altogether.

Well, it's possible that the wireless issue is affecting the pipe programming 
timing enough to expose the bug (stuff like this is usually a problem with 
either not waiting for a register program to take effect and/or programming 
the regs in the wrong order).

> > I think the only thing you'll lose is the boot splash screen.
>
> I did disable fb correctly right? Because I still have a boot splash
> screen.

Yeah, looks like it's off.  Ubuntu may be falling back to using the X vesa 
driver or something though...

Jesse
