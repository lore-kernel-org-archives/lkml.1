Return-Path: <linux-kernel-owner+w=401wt.eu-S1765278AbYARSsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765278AbYARSsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763701AbYARSry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:47:54 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49600 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762869AbYARSrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:47:53 -0500
Date: Fri, 18 Jan 2008 19:47:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: build #343 issue for v2.6.24-rc8-29-g03bbe08 : Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')
Message-ID: <20080118184755.GA20020@uranus.ravnborg.org>
References: <200801181318.30009.toralf.foerster@gmx.de> <20080118122917.GH2559@hacking> <20080118124627.GA17918@uranus.ravnborg.org> <20080118125144.GI2559@hacking> <20080118132242.GA18183@uranus.ravnborg.org> <20080118161452.GJ2559@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118161452.GJ2559@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang.
> >> >Following untested patch should fix it.
> >> >
> >> 
> >> Still has the same problem. ;(
> >Could you please doublecheck that you applied the patch and modpost is rebuilt.
> >If you continue to see the problem could you send me the config (off-list) and
> >I will fix it.
> 
> Sure thing.
> 
> I got something like this:
> 
>   HOSTCC  scripts/mod/modpost.o
>   HOSTLD  scripts/mod/modpost
> 
> So modpost was rebuilt. And I am quite sure I had applied your patch.
> 
> My .config is just the one provided by Toralf. If you need me to send
> you again, please tell me.

I took Toralf's original config and did a build of latest mainline kernel.
I got two section mismatch warnings:
WARNING: vmlinux.o(.text+0x14c8): Section mismatch: reference to .init.data:vsyscall_int80_start (between 'fiddle_vdso' and 'xen_setup_features')
WARNING: vmlinux.o(.text.head+0x247): Section mismatch: reference to .init.text.1:start_kernel (between 'is386' and 'check_x87')

Applying the patch I orginally posted fixed the latter of the two.
The first was fixed by declaring fiddle_vdso __init.

I have tripple chcked that my patch fixes the latter of the two warnings
and it does. So something is different at your place.

Could you send me the exact warning as you see it.

Thanks,

	Sam
