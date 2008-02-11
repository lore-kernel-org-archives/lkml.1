Return-Path: <linux-kernel-owner+w=401wt.eu-S1759518AbYBKSxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518AbYBKSxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYBKSxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:53:37 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:37433 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYBKSxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:53:36 -0500
Date: Mon, 11 Feb 2008 19:53:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Abel Bernabeu <abelbg@m2grp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Elf loader crash while zero-filling .bss
Message-ID: <20080211185344.GA25510@uranus.ravnborg.org>
References: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15577be70802111027s59bc16f7q7c0be42cc44f9ad7@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 07:27:35PM +0100, Abel Bernabeu wrote:
> I've finally found a solution for the crash in load_binary_elf I
> reported last week:
> 
> http://lkml.org/lkml/2008/1/30/171
> 
> The attached patch solves my problem, but please test it yourself...
> 
> set_brk(start, end) allocs just page aligned regions (by "colapsing"
> both extremes to the start of the page in which they lay)... That
> means than even if both pointers are not equal there are still some
> chances that set_brk has allocated no space at all because
> ELF_PAGEALIGN(elf_bss) != ELF_PAGEALIGN(elf_brk).

What architecture was this?
Most architectures align .bss properly but it seems arm does not
and I guess this is needed.

As .bss was empty? in your case you did not trigger
any alignmnet by linker due to largest member in section => boom.

I do think your patch paper over the real bug.

	Sam
