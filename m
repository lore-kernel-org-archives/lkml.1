Return-Path: <linux-kernel-owner+w=401wt.eu-S1423199AbXBCLmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423199AbXBCLmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 06:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423209AbXBCLmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 06:42:42 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:58556 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423199AbXBCLml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 06:42:41 -0500
Date: Sat, 3 Feb 2007 12:38:47 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jon Masters <jonathan@jonmasters.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH/RFC] alternative aproach to: Ban module license tag string
 termination trick
In-Reply-To: <20070203081426.GA10520@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.61.0702031236340.27840@yvahk01.tjqt.qr>
References: <Pine.LNX.4.58.0702022216120.25199@be1.lrz>
 <20070203081426.GA10520@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 3 2007 08:14, Russell King wrote:
>On Sat, Feb 03, 2007 at 03:08:14AM +0100, Bodo Eggert wrote:
>> This patch changes the module license handling code to:
>> - prevent the "GPL\0 for nothing"-trick
>
>You can achieve this effect without changing the existing module
>format, and it's far more difficult to bypass with build-with-
>modified module.h tricks.
>
>+static int check_modinfo_objects(Elf_Shdr *sechdrs,
>+				 unsigned int symindex,
>+				 unsigned int infoindex)
>+{
>+	unsigned int i;
>+	Elf_Sym *sym = (void *)sechdrs[symindex].sh_addr;
>+	char *info = (char *)sechdrs[infoindex].sh_addr;
>+
>+	for (i = 1; i < sechdrs[symindex].sh_size/sizeof(*sym); i++) {
>+		if (sym[i].st_shndx == infoindex &&
>+		    ELF_ST_TYPE(sym[i].st_info) == STT_OBJECT) {
>+			if (strlen(info + sym[i].st_value) + 1 != sym[i].st_size)
>+				return -ENOEXEC;
>+		}
>+	}

What happens when there is no symbol for the "license=GPL\0foo..." string?
To me it looks like we'll miss it.



Jan
-- 
ft: http://freshmeat.net/p/chaostables/
