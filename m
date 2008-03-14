Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYCNEWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYCNEWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 00:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYCNEWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 00:22:14 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:47827 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751078AbYCNEWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 00:22:13 -0400
Message-ID: <47D9FD71.5080909@gawab.com>
Date: Thu, 13 Mar 2008 21:22:09 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
References: <47D828BB.2000702@gawab.com> <200803121236.43267.jbarnes@virtuousgeek.org> <47D8BF6A.9020905@gawab.com> <200803131009.01889.jbarnes@virtuousgeek.org>
In-Reply-To: <200803131009.01889.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Well, the blank screen is probably due to a pipe programming timing problem.  
> IGD devices have been getting less & less sensitive to it over time (830s 
> would hang if you looked at them the wrong way) but it's still not that hard 
> to mis-program them.
>
> Can you narrow down the problem at all?  Did it occur just after a kernel 
> upgrade?  Or did you also upgrade your X driver?  There haven't been any real 
> changes in intelfb since Oct. when Krzysztof added interlaced mode support, 
> so it's weird that you're just seeing problems now...
>   
Not that I can think of. Other than a custom kernel I use standard 
Ubuntu 7.10. I was testing out the kernel starting with 2.6.23-rc4 and 
I've tested each rc, recompiling when a new one came out (except for rc1 
and rc2, they didn't compile). So, when 2.6.25-rc3 came out I recompiled 
and came across this error.

I've removed all fb devices and the blank screen _almost_ never happens 
(also, I _don't_ have to disable the splash screen). There is one 
_big_exception_ the problem still happens when I'm at my University (and 
_very_ consistently). There, I have to disable the splash screen, and 
that ~mostly~ fixes the problem.

I can't believe it could be related, but when I boot the computer at the 
Univ. I get a flood of kernel messages  related to the wireless all the 
time, but still connect:

 > kernel: wlan0_rename: RX too short data frame payload

_Could_ a wireless problem be related to a graphics's problem? I 
wouldn't think so? But, it would explain why I get the blank screen 
mostly when I get the wireless problem. But, then again it could be 
another problem altogether.
> I think the only thing you'll lose is the boot splash screen.
I did disable fb correctly right? Because I still have a boot splash screen.
> But you could also try using vesafb. It works with more hardware than intelfb (including laptops) and we've fixed some vesafb related bugs in the X driver recently, so it may work better for you.
Well, if the fb is not necessary, then I think I'll just leave it out. 
Unless you think using the vesafb would help. But, I thought that the X 
server doesn't interact with the fb driver.

Maybe it's not related to the fb but the other intel driver:

CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_DRM=y
CONFIG_DRM_I915=m


I've updated my config if you need to see the newest version:
http://jdserver.homelinux.org/linux/config-2.6.25-rc5

Justin

