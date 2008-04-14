Return-Path: <linux-kernel-owner+w=401wt.eu-S1760028AbYDNV62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760028AbYDNV62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYDNV6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:58:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56088 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751972AbYDNV6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:58:17 -0400
Date: Mon, 14 Apr 2008 14:58:14 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: Pageflags: Standardize comment inclusion in asm-offsets.h and
 fix MIPS
In-Reply-To: <20080414133213.82a5b76e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804141456410.8740@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804141140430.7154@schroedinger.engr.sgi.com>
 <20080414133213.82a5b76e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008, Andrew Morton wrote:

> afaict this change is not dependent upon the other page-flags changes and
> can and should be merged ahead of the page-flags patches to preserve mips
> bisectability, yes?

It could be merged before yes. There may be a conflict with the earlier 
kbuild fixes though. Sam?

> Mips and sparc64 are hopefully now mended.  powerpc allmodconfig is still
> unwell:
> 
>   CC      arch/powerpc/kernel/asm-offsets.s
> In file included from include/linux/gfp.h:4,
>                  from include/linux/slab.h:14,
>                  from include/linux/percpu.h:5,
>                  from include/asm/time.h:18,
>                  from include/asm/cputime.h:26,
>                  from include/linux/sched.h:67,
>                  from arch/powerpc/kernel/asm-offsets.c:17:
> include/linux/mmzone.h:830:2: error: #error Allocator MAX_ORDER exceeds SECTION_SIZE

Cannot figure out what this has to do with page flags. AFACIT the powerpc 
config is borked because section size is set too low for 64K pages.



