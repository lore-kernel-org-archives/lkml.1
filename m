Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbXCRAFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbXCRAFB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 20:05:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbXCRAFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 20:05:00 -0400
Received: from smtp.osdl.org ([65.172.181.24]:49811 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXCRAE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 20:04:59 -0400
Date: Sat, 17 Mar 2007 17:04:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE fixes
In-Reply-To: <200703172207.52352.bzolnier@gmail.com>
Message-ID: <Pine.LNX.4.64.0703171702060.4964@woody.linux-foundation.org>
References: <200703172207.52352.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 Mar 2007, Bartlomiej Zolnierkiewicz wrote:
> 
> to receive the following updates:
> 
>  b/drivers/ide/Kconfig                       |   48 -
>  b/drivers/ide/Makefile                      |    1 
>  b/drivers/ide/arm/icside.c                  |   13 
>  b/drivers/ide/ide-dma.c                     |    2 
>  b/drivers/ide/ide.c                         |    4 
>  b/drivers/ide/mips/au1xxx-ide.c             |    3 
>  b/drivers/ide/pci/Makefile                  |    1 
>  b/drivers/ide/pci/cmd64x.c                  |   45 -
>  b/drivers/ide/pci/jmicron.c                 |   29 
>  b/drivers/ide/pci/scc_pata.c                |  858 ++++++++++++++++++++++++++++
>  b/drivers/ide/setup-pci.c                   |    5 
>  b/include/asm-mips/mach-au1x00/au1xxx_ide.h |   34 -
>  drivers/ide/ppc/scc_pata.c                  |  858 ----------------------------
>  13 files changed, 915 insertions(+), 986 deletions(-)

Please use

	git diff -M --stat --summary 

to generate the diffstat (where the "-M" is the important part). Your 
"scc_pata.c" change was a pure rename, but because you didn't ask for 
rename detection, it got shown as a file create/delete pair. It *should* 
have looked like this:

 drivers/ide/Kconfig                       |   48 +++++------------------------
 drivers/ide/Makefile                      |    1 -
 drivers/ide/arm/icside.c                  |   13 +-------
 drivers/ide/ide-dma.c                     |    2 +-
 drivers/ide/ide.c                         |    4 --
 drivers/ide/mips/au1xxx-ide.c             |    3 +-
 drivers/ide/pci/Makefile                  |    1 +
 drivers/ide/pci/cmd64x.c                  |   45 ++++++++++++---------------
 drivers/ide/pci/jmicron.c                 |   29 ++++++++++++++---
 drivers/ide/{ppc => pci}/scc_pata.c       |    0
 drivers/ide/setup-pci.c                   |    5 ---
 include/asm-mips/mach-au1x00/au1xxx_ide.h |   34 --------------------
 12 files changed, 57 insertions(+), 128 deletions(-)
 rename drivers/ide/{ppc => pci}/scc_pata.c (100%)

which is a lot more accurate than what you get by feeding a diff through 
"diffstat" that has no clue about renames (look at the summary for number 
of lines changed ;)

		Linus
