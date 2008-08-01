Return-Path: <linux-kernel-owner+w=401wt.eu-S1760341AbYHAWXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760341AbYHAWXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 18:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbYHAWXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 18:23:03 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:56684 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754672AbYHAWXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 18:23:01 -0400
Date: Sat, 2 Aug 2008 07:22:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh: fix LIBGCC
Message-ID: <20080801222217.GD13448@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080801221344.GI19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801221344.GI19682@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 01:13:44AM +0300, Adrian Bunk wrote:
> Commit f15cbe6f1a4b4d9df59142fc8e4abb973302cf44
> (sh: migrate to arch/sh/include/) moved KBUILD_CFLAGS
> (which is used by LIBGCC) below LIBGCC, causing build
> errors like the following:
> 
> <--  snip  -->
> 
> ...
>   LD      .tmp_vmlinux1
> arch/sh/kernel/built-in.o: In function `module_clk_recalc':
> clock-sh4.c:(.text+0x80f0): undefined reference to `__udivsi3_i4i'
> ...
> make[1]: *** [.tmp_vmlinux1] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
That's interesting, none of my compilers had difficulty with it, whereas
it seems your toolchain couldn't report the libgcc location at all.

Anyways, applied, thanks.
