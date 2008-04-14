Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbYDNUcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbYDNUcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 16:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbYDNUcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 16:32:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754379AbYDNUcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 16:32:41 -0400
Date: Mon, 14 Apr 2008 13:32:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: ralf@linux-mips.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: Pageflags: Standardize comment inclusion in asm-offsets.h and
 fix MIPS
Message-Id: <20080414133213.82a5b76e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804141140430.7154@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0804141140430.7154@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 11:43:08 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> Add the ability to pass comments into asm-offsets.h by generating asm
> output like
> 
> -># comment line
> 
> Mips needs this feature to preserve the comments that are in asm-mips/asm-offsets.h
> right now.
> 
> Then remove the special handling for mips from Kbuild and convert mips to use
> the new string to include the comments.

OK, let's try that.  Ralf, could you please review it?


afaict this change is not dependent upon the other page-flags changes and
can and should be merged ahead of the page-flags patches to preserve mips
bisectability, yes?

Mips and sparc64 are hopefully now mended.  powerpc allmodconfig is still
unwell:

  CC      arch/powerpc/kernel/asm-offsets.s
In file included from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/percpu.h:5,
                 from include/asm/time.h:18,
                 from include/asm/cputime.h:26,
                 from include/linux/sched.h:67,
                 from arch/powerpc/kernel/asm-offsets.c:17:
include/linux/mmzone.h:830:2: error: #error Allocator MAX_ORDER exceeds SECTION_SIZE

