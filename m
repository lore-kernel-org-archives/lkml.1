Return-Path: <linux-kernel-owner+w=401wt.eu-S1750943AbXBXLjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750943AbXBXLjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 06:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbXBXLjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 06:39:18 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:52758 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXBXLjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 06:39:17 -0500
Date: Sat, 24 Feb 2007 12:39:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Markus Gutschke <markus@google.com>
Cc: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       dhowells@redhat.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>
Subject: Re: [PATCH 0/4] coredump: core dump masking support v3
Message-ID: <20070224113916.GA9378@atrey.karlin.mff.cuni.cz>
References: <45D5B2E3.3030607@hitachi.com> <45DFB1C7.1030205@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DFB1C7.1030205@google.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Kawai, Hidehiro wrote:
> >This patch series is version 3 of the core dump masking feature,
> >which provides a per-process flag not to dump anonymous shared
> >memory segments.
> 
> I just wanted to remind you that you need to be careful about dumping 
> the [vdso] segment no matter whether you omit other segments. I didn't 
> actually try running your patches, and if the kernel doesn't actually 
> consider this segment anonymous and shared, things might already work 
> fine as is.
> 
> In any case, you can check with "readelf -a", if the [vdso] segment is 
> there. And you will find that if you forget to dump it, "gdb" can no 
> longer give you stack traces on call chains that involve signal handlers.
> 
> As an alternative to your kernel patch, you could achieve the same goal 
> in user space, by linking my coredumper 
> http://code.google.com/p/google-coredumper/ into your binaries and 
> setting up appropriate signal handlers. An equivalent patch for 
> selectively omitting memory regions would be trivial to add. While this 
> does give you more flexibility, it of course has the drawback of 
> requiring you to change your applications, so there still is some 
> benefit in a kernelspace solution.

"We are too lazy to change 0.01% of apps that actually need it" is not
good enough reason to push the feature into kernel, I'd say.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
