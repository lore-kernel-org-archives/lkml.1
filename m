Return-Path: <linux-kernel-owner+w=401wt.eu-S934337AbYEBLmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337AbYEBLmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762705AbYEBLmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:42:00 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39094 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762620AbYEBLl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:41:59 -0400
Message-ID: <481AFDC2.7030807@s5r6.in-berlin.de>
Date: Fri, 02 May 2008 13:40:50 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] fs: use get_unaligned_* helpers
References: <1209700378.22362.23.camel@brick>
In-Reply-To: <1209700378.22362.23.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
>  fs/partitions/ldm.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/partitions/ldm.h b/fs/partitions/ldm.h
...
>  /* Most numbers we deal with are big-endian and won't be aligned. */
> -#define BE16(x)			((u16)be16_to_cpu(get_unaligned((__be16*)(x))))
> -#define BE32(x)			((u32)be32_to_cpu(get_unaligned((__be32*)(x))))
> -#define BE64(x)			((u64)be64_to_cpu(get_unaligned((__be64*)(x))))
> +#define BE16(x)		get_unaligned_be16((x))
> +#define BE32(x)		get_unaligned_be32((x))
> +#define BE64(x)		get_unaligned_be64((x))

Why the double parentheses?

More importantly, I would say ldm.c should rather use
get_unaligned_be*() directly.  No need to hide what these macros are
about by using a local alias.

After that, ldm.c should be inspected for whether really all of the
accesses are unaligned.  If there are any which are guaranteed to be
aligned, they should of course be turned into be*_to_cpu().  But
separately from this conversion to get_unaligned_be*().
-- 
Stefan Richter
-=====-==--- -=-= ---=-
http://arcgraph.de/sr/
