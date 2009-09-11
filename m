Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZIKTZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZIKTZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZIKTZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:25:15 -0400
Received: from fifo99.com ([67.223.236.141]:57238 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbZIKTZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:25:14 -0400
Subject: Re: [PATCH] [16/21] HWPOISON: The high level memory error handler
 in the VM v7
From: Daniel Walker <dwalker@fifo99.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: npiggin@suse.de, riel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090911184845.38A6EB1758@basil.firstfloor.org>
References: <20090911848.933193846@firstfloor.org>
	 <20090911184845.38A6EB1758@basil.firstfloor.org>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 12:25:49 -0700
Message-Id: <1252697149.28368.12.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 20:48 +0200, Andi Kleen wrote:
> -               "VmallocChunk:   %8lu kB\n",
> +               "VmallocChunk:   %8lu kB\n"
> +#ifdef CONFIG_MEMORY_FAILURE
> +               "HardwareCorrupted: %8lu kB\n"
> +#endif
> +               ,
>                 K(i.totalram),
>                 K(i.freeram),
>                 K(i.bufferram),
> @@ -140,6 +144,9 @@ static int meminfo_proc_show(struct seq_
>                 (unsigned long)VMALLOC_TOTAL >> 10,
>                 vmi.used >> 10,
>                 vmi.largest_chunk >> 10
> +#ifdef CONFIG_MEMORY_FAILURE
> +               ,atomic_long_read(&mce_bad_pages) << (PAGE_SHIFT - 10)
> +#endif
>                 );

The rest of your patches are totally clean, except this one .. It has
some warning, but one error in the second ifdef block above ..

Daniel

