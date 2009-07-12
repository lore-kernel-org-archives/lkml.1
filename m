Return-Path: <linux-kernel-owner+w=401wt.eu-S1752844AbZGLEvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbZGLEvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 00:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbZGLEu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 00:50:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZGLEu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 00:50:58 -0400
Message-ID: <4A596A57.7080500@zytor.com>
Date: Sat, 11 Jul 2009 21:45:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Siarhei Liakh <sliakh.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, linux-cris-kernel@axis.com
Subject: Re: [PATCH v5] RO/NX protection for loadable kernel modules
References: <817ecb6f0907081610p6d60341cudbee42685eac1347@mail.gmail.com> <200907111821.47769.rusty@rustcorp.com.au> <20090711084958.69ff9196@infradead.org> <200907121410.39874.rusty@rustcorp.com.au>
In-Reply-To: <200907121410.39874.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 
> OTOH, a quick grep shows currently only cris does kmalloc, and that's a config 
> option.
> 
> It might be time to unify this code.  If we rename MODULE_START to 
> MODULE_VADDR on MIPS, then ignoring CRIS there's only two real variants; 
> vmalloc and __vmalloc.
> 
> (I like the idea of trying kmalloc and falling back, simply because it reduces 
> TLB pressure, but that's probably best done after unification).
> 

Instead of plain kmalloc we could also have separate R-- and R-X slabs
(the normal kmalloc slabs already being RW-).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

