Return-Path: <linux-kernel-owner+w=401wt.eu-S1756940AbXIBJkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbXIBJkF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 05:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbXIBJjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 05:39:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:39113 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbXIBJjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 05:39:54 -0400
Subject: Re: BUG POWERPC: snd-powermac hangs since 'Merge 32 and 64 bits
	asm-powerpc/io.h'
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Vasilevsky <djvasi@gmail.com>
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <d8658f80708312153j150a44ben3dcc3c70f800eada@mail.gmail.com>
References: <d8658f80708312153j150a44ben3dcc3c70f800eada@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 02 Sep 2007 11:40:14 +0200
Message-Id: <1188726014.5972.128.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-09-01 at 00:53 -0400, Dave Vasilevsky wrote:
> When playing audio with the snd-powermac driver on a PowerMac G4
> Quicksilver (Tumbler audio) the sound hangs after a few seconds.
> 
> - The time before a hang varies from one second to one minute.
> - Killing the process playing sound and starting again will allow
> sound to continue (for a few more seconds). 
> - Many different userspace audio systems and different audio sources
> all encounter this bug--definitely a kernel issue.
> - Vanilla kernels from 2.6.20 up to git HEAD show this behavior.
> Others have reported this bug on distro kernels.[1][2] 
> 
> I used git-bisect to find that the regression first occured after git
> commit 68a64357d15ae4f596e92715719071952006e83c
> "powerpc: Merge 32 and 64 bits asm-powerpc/io.h" by benh.[3]
> 
> My kernel debugging skills are admittedly limited, but I scattered
> printks through some relevant files and found that audio stops just as
> snd_pmac_pcm_update in sound/ppc/pmac.c encounters a struct dbdma_cmd
> with xfer_status == 0x8088. Normally it should be 0x84 (ie: ACTIVE |
> RUN) or 0x0. Hopefully this means something to somebody. I'm willing
> to do more debugging if more information is necessary, kindly CC me on
> replies to this message. 

.../... strange. I'm travelling at the moment. I'll try to have a look,
but don't hesistate to "ping" me if you don't hear from me in the
upcoming couple of weeks.

Cheers,
Ben.


