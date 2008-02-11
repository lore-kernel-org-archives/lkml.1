Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYBKUgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYBKUgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYBKUgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:36:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37237 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbYBKUgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:36:08 -0500
Message-ID: <47B0B1AB.3020203@zytor.com>
Date: Mon, 11 Feb 2008 12:35:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Abel Bernabeu <abelbg@m2grp.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] Elf loader crash while zero-filling .bss
References: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com>  <15577be70802111032l6ea6d2fagba2da4462c739d66@mail.gmail.com>  <Pine.LNX.4.64.0802111944220.7699@twin.jikos.cz> <15577be70802111111x36f61433p321e5b8175a13d08@mail.gmail.com> <Pine.LNX.4.64.0802112026470.30955@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0802112026470.30955@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 11 Feb 2008, Abel Bernabeu wrote:
> 
>> In such a way that set_brk(0x0, 0x100) does not alloc any space at all. 
>> There are just more ways to get no memory allocation than 
>> set_brk(elf_bss, elf_bss) (the equalness condition i've changed).
>> Sorry, the correct description for the patch may be:
>> set_brk(start, end) allocs just page aligned regions (by "colapsing"
>> both extremes to the END of the page in which they lay)... That means
>> than even if both pointers are not equal there are still some chances
>> that set_brk has allocated no space at all because because
>> ELF_PAGEALIGN(elf_bss) == ELF_PAGEALIGN(elf_brk)
> 
> Now, the question is whether it is valid for ELF binary to not have the 
> end of .bss section (if present at all) not page-aligned.
> 

Why wouldn't it be?  It would, however, be valid to the kernel to round 
it up to the next boundary.

	-hpa
