Return-Path: <linux-kernel-owner+w=401wt.eu-S1759193AbYDAX01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbYDAX01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 19:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbYDAX0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:26:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:25616 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbYDAX0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cPsf2bjUR1DjgMOhViyiJkUZNWfTA9DC3uEVX27tMACFMA5gM8PcJiV3yWEmbCXbd+7JgTV8C8K9CWxjyj+R1rtGMsZrmXC9nU1bnZ/uO9Etx5e/GnQ79+yYr59NNoIo+kwI485SEjj9JxpmdzBHf7A3FguDsvoobSwMes1uASk=
Message-ID: <29495f1d0804011626n2399d69aj7566df7f78953458@mail.gmail.com>
Date: Tue, 1 Apr 2008 16:26:14 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: HugeTLB vs. SH3 cpu
Cc: wli@holomorphy.com, lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080401225809.GC32269@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401225809.GC32269@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/08, Adrian Bunk <bunk@kernel.org> wrote:
> fs/Kconfig says:
>
>  config HUGETLBFS
>         bool "HugeTLB file system support"
>         depends on X86 || IA64 || PPC64 || SPARC64 || (SUPERH && MMU) || BROKEN
>
>
>  arch/sh/mm/Kconfig says:
>
>  choice
>         prompt "HugeTLB page size"
>         depends on HUGETLB_PAGE && (CPU_SH4 || CPU_SH5) && MMU

So the problem is that SH3 is allowed to enable
HUGETLB_PAGE/HUGETLBFS, but only SH4/5 define the HPAGE_SHIFT macro,
due to some #ifdeffery on the hugepage size. So either the choice
needs to be extended to include CPU_SH3 (which builds here, when
changed) or the HUGETLBFS conditional needs to depend more
specifically on SH4/5 and not just SUPERH. I think the arch maintainer
has to make that call, as I don't know the hardware to say if SH3
actually supports multiple hugepage sizes.

Thanks,
Nish
