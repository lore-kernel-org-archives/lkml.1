Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbXJJXOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbXJJXOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 19:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXJJXOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 19:14:04 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51439 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752475AbXJJXOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:14:03 -0400
Date: Thu, 11 Oct 2007 01:14:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: olecom@flower.upol.cz, "LKML (Cc removed)" <linux-kernel@vger.kernel.org>
Subject: Re: coding for optimizations (Re: [PATCH 1/2] i386: mce cleanup
	part1: functional change)
Message-ID: <20071010231428.GU16424@stusta.de>
References: <11919341961890-git-send-email-joerg.roedel@amd.com> <11919341961530-git-send-email-joerg.roedel@amd.com> <E1IfHZg-0003dp-FA@flower> <20071009160605.GC13205@amd.com> <20071009173317.GD22435@flower.upol.cz> <20071009183011.GE13205@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071009183011.GE13205@amd.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 08:30:11PM +0200, Joerg Roedel wrote:
>...
> But you are right with the redundant mca and mce variables. They are not
> needed and I will inline the cpu_has() checks into the condition check.
> I'll resubmit tomorrow.

Please don't let Oley bring you away from the right path.

It is your job to write readable C code, and it's the compiler's job to 
transform this C code into efficient machine code.

And non-ancient gcc versions are usually quite good in optimizing code.

And saving code in a variable before using it might even result in the 
same assembler code.

It is personal preference whether you use variables or not in this case 
(both seem to be equally readable) so you can do it any way you like, 
but don't try to guess what gcc might make out of it.

We have problems with the size of the kernel image, but we need to solve 
them with the bigger knobs that have measurable effects, not by wasting 
our time on guessing how gcc might handle a single if.

It's also a quite ill idea to think about whether gcc might produce a 
few bytes more or less code at the if when there's such a long printk() 
in the middle...

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

