Return-Path: <linux-kernel-owner+w=401wt.eu-S1762673AbYDXQD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762673AbYDXQD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbYDXQDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:03:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:48569 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755860AbYDXQDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:03:19 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+6q5Rx8wK6b2jExbcncjffFJIyLLT5Q8ZwkQwBR0
	Ji1sKLAIrom3Ar
Date: Thu, 24 Apr 2008 18:03:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Dave Airlie <airlied@gmail.com>
cc: Gerhard Pircher <gerhard_pircher@gmx.net>, linux-kernel@vger.kernel.org,
       adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [2.6.25-rc6] possible regression: X server dying
In-Reply-To: <Pine.LNX.4.64.0804082256270.4987@axis700.grange>
Message-ID: <Pine.LNX.4.64.0804241715320.7642@axis700.grange>
References: <47E82D68.5070305@imap.cc>  <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>
  <47E83D14.8070800@imap.cc>  <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com>
  <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com> 
 <21d7e9970804060044i25b36802p1859ca25fa532494@mail.gmail.com> 
 <20080406143434.106940@gmx.net> <21d7e9970804071527g14402783j26bfdbd2beb1b026@mail.gmail.com>
 <Pine.LNX.4.64.0804082256270.4987@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Guennadi Liakhovetski wrote:

> Hm, so looks like I'm not seeing some ghosts on mine either. 2.6.25-rc8 
> xorg runs under etch, but enters a tight (no syscalls) loop woth 100% CPU 
> load under lenny. A 2.6.24 based kernel works under both etch and lenny... 
> Haven't had time to try to localize the problem. Glint xorg driver, DRM 
> and AGP are off, CONFIG_FB_PM2=y.

Ok, here's more info. It DOES seem to be a regression. I spent half a day 
yesterday trying to trace this down, with no success. Multiple bisect 
attempts ended up with non-bootable kernels on the very first iteration. 
Today I just wanted to post all possible logs / configs to Bugzilla and - 
it "suddenly" worked... And the change that made it work was - I disabled 
CONFIG_FB_PM2 in the kernel...

So, I think, this shall be qualified as a regression, although, I have no 
idea where. pm2fb.c itself hasn't (effectively for little endian) changed 
since 2.6.24. To make it visual

		etch		lenny

v2.6.24		works		works
v2.6.25		works		fails

/me thinks he should trade his ap400 to the Linux Kernel Testers Inc. for 
LOTS of money.

Thanks
Guennadi
---
Guennadi Liakhovetski
