Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbYI3Ge4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbYI3Ge4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 02:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYI3Ger
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 02:34:47 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54193 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbYI3Geq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 02:34:46 -0400
Subject: Re: [patch 3/4] cpu alloc: The allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, rusty@rustcorp.com.au, jeremy@goop.org,
       ebiederm@xmission.com, travis@sgi.com, herbert@gondor.apana.org.au,
       xemul@openvz.org
In-Reply-To: <20080929193516.278278446@quilx.com>
References: <20080929193500.470295078@quilx.com>
	 <20080929193516.278278446@quilx.com>
Date: Tue, 30 Sep 2008 09:35:59 +0300
Message-Id: <1222756559.10002.23.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-29 at 12:35 -0700, Christoph Lameter wrote:
> Index: linux-2.6/mm/cpu_alloc.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/mm/cpu_alloc.c	2008-09-29 13:09:33.000000000 -0500
> @@ -0,0 +1,185 @@
> +/*
> + * Cpu allocator - Manage objects allocated for each processor
> + *
> + * (C) 2008 SGI, Christoph Lameter <cl@linux-foundation.org>
> + * 	Basic implementation with allocation and free from a dedicated per
> + * 	cpu area.
> + *
> + * The per cpu allocator allows a dynamic allocation of a piece of memory on
> + * every processor. A bitmap is used to track used areas.
> + * The allocator implements tight packing to reduce the cache footprint
> + * and increase speed since cacheline contention is typically not a concern
> + * for memory mainly used by a single cpu. Small objects will fill up gaps
> + * left by larger allocations that required alignments.
> + */
> +#include <linux/mm.h>
> +#include <linux/mmzone.h>
> +#include <linux/module.h>
> +#include <linux/percpu.h>
> +#include <linux/bitmap.h>
> +#include <asm/sections.h>
> +#include <linux/bootmem.h>
> +
> +/*
> + * Basic allocation unit. A bit map is created to track the use of each
> + * UNIT_SIZE element in the cpu area.
> + */
> +#define UNIT_TYPE int
> +#define UNIT_SIZE sizeof(UNIT_TYPE)
> +
> +int units;	/* Actual available units */

What is this thing? Otherwise looks good to me.

