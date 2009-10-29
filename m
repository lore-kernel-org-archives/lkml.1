Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbZJ2Fj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbZJ2Fj4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 01:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZJ2Fjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 01:39:55 -0400
Received: from gherkin.frus.com ([192.158.254.49]:58889 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbZJ2Fjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 01:39:55 -0400
Date: Thu, 29 Oct 2009 00:39:47 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: debian-alpha@lists.debian.org
Subject: Re: [BUG] 2.6.32-rc5 build failure on Alpha
Message-ID: <20091029053947.GA9872@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 10:53:05PM -0500, Bob Tracy wrote:
> Mainline 2.6.32-rc5 kernel build failure.  The last few lines of the kernel
> build output are:
> 
>   LD      vmlinux.o
>   MODPOST vmlinux.o
> WARNING: "saved_config" [vmlinux] is COMMON symbol
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/alpha/kernel/vmlinux.lds:241: undefined symbol `THREAD_SIZE' referenced in expression
> make: *** [.tmp_vmlinux1] Error 1

> In arch/alpha/include/asm/thread_info.h, THREAD_SIZE is defined as
> (2*PAGE_SIZE).

Ok.  Found it.  The THREAD_SIZE definition is inside a
"#ifndef __ASSEMBLY__" block, so it never gets referenced (because
"__ASSEMBLY__" is defined for the "vmlinux.lds" build).  The obvious
suggested fix is to move the definition outside the block.

--Bob
