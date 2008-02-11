Return-Path: <linux-kernel-owner+w=401wt.eu-S1760320AbYBKT2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320AbYBKT2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757651AbYBKT2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:28:44 -0500
Received: from styx.suse.cz ([82.119.242.94]:39925 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758338AbYBKT2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:28:43 -0500
Date: Mon, 11 Feb 2008 20:28:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Abel Bernabeu <abelbg@m2grp.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Elf loader crash while zero-filling .bss
In-Reply-To: <15577be70802111111x36f61433p321e5b8175a13d08@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802112026470.30955@jikos.suse.cz>
References: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com> 
 <15577be70802111032l6ea6d2fagba2da4462c739d66@mail.gmail.com> 
 <Pine.LNX.4.64.0802111944220.7699@twin.jikos.cz>
 <15577be70802111111x36f61433p321e5b8175a13d08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Abel Bernabeu wrote:

> In such a way that set_brk(0x0, 0x100) does not alloc any space at all. 
> There are just more ways to get no memory allocation than 
> set_brk(elf_bss, elf_bss) (the equalness condition i've changed).
> Sorry, the correct description for the patch may be:
> set_brk(start, end) allocs just page aligned regions (by "colapsing"
> both extremes to the END of the page in which they lay)... That means
> than even if both pointers are not equal there are still some chances
> that set_brk has allocated no space at all because because
> ELF_PAGEALIGN(elf_bss) == ELF_PAGEALIGN(elf_brk)

Now, the question is whether it is valid for ELF binary to not have the 
end of .bss section (if present at all) not page-aligned.

-- 
Jiri Kosina
SUSE Labs
