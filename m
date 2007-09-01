Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbXIAE6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbXIAE6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 00:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbXIAE60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 00:58:26 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:5902 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXIAE60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 00:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nd9bdk7uqvtMe3aBpFUQF4BdaHRi9F5UvhuOC8PmsYP/FGgD6/LxMMmtb063jw4xsMOCzJ2ojgQS0bx1zVAk8O4M5sqgUMoBE2DJYnJwAdrg6KbwuAAdtr4JA47ZypIhLQoMznMyJm4sW1Vnem21bfV0yD1o14y/u21J2DQ/lek=
Message-ID: <d8658f80708312158g6b85a625i171d1bf2fd7e2e4e@mail.gmail.com>
Date: Sat, 1 Sep 2007 00:58:24 -0400
From: "Dave Vasilevsky" <djvasi@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG POWERPC: snd-powermac hangs since 'Merge 32 and 64 bits asm-powerpc/io.h'
In-Reply-To: <d8658f80708312153j150a44ben3dcc3c70f800eada@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d8658f80708312153j150a44ben3dcc3c70f800eada@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When playing audio with the snd-powermac driver on a PowerMac G4
Quicksilver (Tumbler audio) the sound hangs after a few seconds.

- The time before a hang varies from one second to one minute.
- Killing the process playing sound and starting again will allow
sound to continue (for a few more seconds).
- Many different userspace audio systems and different audio sources
all encounter this bug--definitely a kernel issue.
- Vanilla kernels from 2.6.20 up to git HEAD show this behavior.
Others have reported this bug on distro kernels.[1][2]

I used git-bisect to find that the regression first occured after git
commit 68a64357d15ae4f596e92715719071952006e83c "powerpc: Merge 32 and
64 bits asm-powerpc/io.h" by benh.[3]

My kernel debugging skills are admittedly limited, but I scattered
printks through some relevant files and found that audio stops just as
snd_pmac_pcm_update in sound/ppc/pmac.c encounters a struct dbdma_cmd
with xfer_status == 0x8088. Normally it should be 0x84 (ie: ACTIVE |
RUN) or 0x0. Hopefully this means something to somebody. I'm willing
to do more debugging if more information is necessary, kindly CC me on
replies to this message.

Thank you for your time,
Dave Vasilevsky


[1] https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/87652
[2] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=436723
[3]  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=68a64357d15ae4f596e92715719071952006e83c
