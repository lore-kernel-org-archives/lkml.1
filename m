Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYEPHRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYEPHRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 03:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYEPHQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 03:16:53 -0400
Received: from www.tglx.de ([62.245.132.106]:35567 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYEPHQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 03:16:52 -0400
Date: Fri, 16 May 2008 09:15:54 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Justin Madru <jdm64@gawab.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Airlie <airlied@linux.ie>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       Antonino Daplas <adaplas@gmail.com>,
       Roman Zippel <zippel@linux-m68k.org>, Greg KH <gregkh@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [regression bisected] HR-timers bug >=2.6.25
In-Reply-To: <482C8FD6.10808@gawab.com>
Message-ID: <alpine.LFD.1.10.0805160909450.3255@apollo.tec.linutronix.de>
References: <482C8FD6.10808@gawab.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Justin Madru wrote:
> I've reported this problem previously:
> http://lkml.org/lkml/2008/3/12/290
> http://bugzilla.kernel.org/show_bug.cgi?id=10235
> https://bugs.freedesktop.org/show_bug.cgi?id=15602
> 
> This bug is still in mainline as of 2.6.26-rc1. (affected versions 2.6.25-rc0
> - 2.6.26-rc1)
> 
> Ever since 2.6.25-rc3 (the first rc I tested), my screen would blank out when
> mode switching from the Ubuntu uplash to the gdm login. Normally after the
> boot splash, the screen goes black and "refreshes" to select the correct
> resolution. But when using a kernel newer than 2.6.24 the screen doesn't come
> back on - it stays blank. This doesn't happen every time, but a good majority
> of the time. The workaround is to disable the splash, and that fixes the
> problem almost completely.
> 
> I did a git bisect. Rebooting 3 times if the problem didn't occur just to make
> sure.
> The git bisect reports that it's timing related - which is what Jesse Barnes
> said it could be.

Well, it's a timing problem related to splash which is exposed by the
scheduler timing changes. This is neither a hrtimer nor a scheduler
bug. Something in the splash / video driver switchover relies on some
obscure timing which is nowhere guaranteed.

Thanks,
	tglx


