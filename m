Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYJYKHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYJYKHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 06:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYJYKHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 06:07:35 -0400
Received: from mx.sz.bfs.de ([194.94.69.70]:59840 "EHLO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYJYKHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 06:07:34 -0400
X-Greylist: delayed 1657 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2008 06:07:33 EDT
Message-ID: <4902E95E.2040307@bfs.de>
Date: Sat, 25 Oct 2008 11:39:42 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Joe Damato <ice799@gmail.com>
Cc: linux-x86_64@vger.kernel.org, linux-newbie@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] x86: Cleanup idt, gdt/ldt/tss structs
References: <> <1224904532-9586-1-git-send-email-ice799@gmail.com>
In-Reply-To: <1224904532-9586-1-git-send-email-ice799@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi joe,
i am not a maintainer here so my comments are my private commonts so ..
1. this is a lot of work and thx for it

patch 2/12:
personaly i am not a fan of typedefs especially like this one:
typedef struct gate_struct gate_desc;
they make people think they move a int or something around that is a fat
struct in real. do you really need a typedef ? or can you live with "struct gate_struct" instead ?

(see: also http://www.linuxjournal.com/article/5780 section: typedef Is Evil )

patch 6/12 (same goes for others)
is is possible to be more verbose ? what does l/d/g mean ? maybe an enum ?
+	desc->avl    = flags & 0x1;
+	desc->l      = (flags & 0x2) >> 1;
+	desc->d      = (flags & 0x4) >> 2;
+	desc->g      = (flags & 0x8) >> 3;

i noticed you are accessing hi/lo often. you can use a macro like:

from: highuid.h
#define low_16_bits(x)  ((x) & 0xFFFF)
#define high_16_bits(x) (((x) & 0xFFFF0000) >> 16)

or use a union {
	int foo;
	char bar[4];
	}



keep on going ...
	walter


Joe Damato schrieb:
> Hi -
> 
> This is my first submission to the kernel, so (beware!) please let me know if I can make any improvements on these patches.
> 
> I attempted to clean up the x86 structs for 32bit cpus that store IDT/LDT/GDT data by removing the fields labeled "a" and "b" in favor of more descriptive field names. I added some macros and went through the kernel cleaning up the various places where "a" and "b" were used.
> 
> I tried building my kernel with my .config and then also did a make allyesconfig build to help ensure I found everything that was using the old structure names. I also tried a few grep patterns. Hopefully I got everyone out.
> 
> 
> Thanks,
> Joe Damato
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
