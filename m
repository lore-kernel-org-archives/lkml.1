Return-Path: <linux-kernel-owner+w=401wt.eu-S1753531Ab0AIA5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab0AIA5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 19:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409Ab0AIA5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 19:57:42 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:51946 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab0AIA5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 19:57:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kdX/i4iTuwuLMV2OhtYFwHteH3d20dXGJQckXiAQGu9UF/PsZDswLHozjTp2nPAahN
         VzMyqM3E2Mzm5BhOPGY7J8k+VkcWW39M+maAaoo7XvMDVEE/SFT1cPsB3U3+texOfUtZ
         5ky7JUnCUflLAzgw4PyoDqLRK3EVvybAi2Fh0=
MIME-Version: 1.0
In-Reply-To: <20100108220538.23489.15477.stgit@warthog.procyon.org.uk>
References: <20100108220516.23489.11319.stgit@warthog.procyon.org.uk> 
	<20100108220538.23489.15477.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 8 Jan 2010 19:57:20 -0500
Message-ID: <8bd0f97a1001081657p57d16013g73d0530c930bade6@mail.gmail.com>
Subject: Re: [PATCH 5/6] NOMMU: Fix race between ramfs truncation and shared 
	mmap
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, lethal@linux-sh.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 17:05, David Howells wrote:
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -389,7 +389,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
>  extern void arch_unmap_area(struct mm_struct *, unsigned long);
>  extern void arch_unmap_area_topdown(struct mm_struct *, unsigned long);
>  #else
> -extern void arch_pick_mmap_layout(struct mm_struct *mm) {}
> +static inline void arch_pick_mmap_layout(struct mm_struct *mm) {}
>  #endif

oh, i guess the static inline change was moved to this patch for some reason ...
-mike
