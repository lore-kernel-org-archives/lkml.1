Return-Path: <linux-kernel-owner+w=401wt.eu-S1751391AbZLRAFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbZLRAFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbZLRAFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:05:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZLRAFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:05:19 -0500
Message-ID: <4B2AC710.2090705@redhat.com>
Date: Thu, 17 Dec 2009 19:04:32 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Fix objdump version check in arch/x86/tools/chkobjdump.awk
References: <200912172326.nBHNQaQl024796@imap1.linux-foundation.org> <tip-8c63450718ea62ee3a70bffde170b4d15fc72d3c@git.kernel.org>
In-Reply-To: <tip-8c63450718ea62ee3a70bffde170b4d15fc72d3c@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

tip-bot for akpm@linux-foundation.org wrote:
> Commit-ID:  8c63450718ea62ee3a70bffde170b4d15fc72d3c
> Gitweb:     http://git.kernel.org/tip/8c63450718ea62ee3a70bffde170b4d15fc72d3c
> Author:     akpm@linux-foundation.org <akpm@linux-foundation.org>
> AuthorDate: Thu, 17 Dec 2009 15:26:36 -0800
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Thu, 17 Dec 2009 15:34:29 -0800
> 
> x86: Fix objdump version check in arch/x86/tools/chkobjdump.awk
> 
> It says
> 
> Warning: objdump version  is older than 2.19
> Warning: Skipping posttest.
> 
> because it used the wrong field from `objdump -v':
> 
> akpm:/usr/src/25> /opt/crosstool/gcc-4.0.2-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-objdump -v
> GNU objdump 2.16.1
> Copyright 2005 Free Software Foundation, Inc.
> This program is free software; you may redistribute it under the terms of
> the GNU General Public License.  This program has absolutely no warranty.


Oh, I didn't know that.
On my environment, objdump shows version in below format.
---
$ objdump -v
GNU objdump version 2.19.51.0.14-1.fc11 20090722
Copyright 2008 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License version 3 or (at your option) any later version.
This program has absolutely no warranty.
---

Hmm, maybe, we need to check if ($3 == "version") to decide
which argument we should use.

Thank you,


> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> LKML-Reference: <200912172326.nBHNQaQl024796@imap1.linux-foundation.org>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> ---
>  arch/x86/tools/chkobjdump.awk |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/tools/chkobjdump.awk b/arch/x86/tools/chkobjdump.awk
> index 0d13cd9..5bbb5a3 100644
> --- a/arch/x86/tools/chkobjdump.awk
> +++ b/arch/x86/tools/chkobjdump.awk
> @@ -9,7 +9,7 @@ BEGIN {
>  }
>  
>  /^GNU/ {
> -	split($4, ver, ".");
> +	split($3, ver, ".");
>  	if (ver[1] > od_ver ||
>  	    (ver[1] == od_ver && ver[2] >= od_sver)) {
>  		exit 1;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

