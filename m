Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbYBFWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbYBFWsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbYBFWsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:48:10 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757697AbYBFWsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:48:08 -0500
Date: Wed, 6 Feb 2008 14:47:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Harald Arnesen" <skogtun.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, tomof@acm.org
Subject: Re: Latest git oopses during boot
Message-Id: <20080206144732.5a1a2c3b.akpm@linux-foundation.org>
In-Reply-To: <8120cfd40802060832w2dd3631foad324b3633427230@mail.gmail.com>
References: <8120cfd40802060832w2dd3631foad324b3633427230@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Feb 2008 17:32:22 +0100
"Harald Arnesen" <skogtun.linux@gmail.com> wrote:

> Photo of screen attached (no serial terminal, and alas, no decent
> tripod either).

Thanks, but you've disabled so many debug options that the trace isn't
very useful.

> git-bisect gives me this:
> 
> 6b7b651055221127304a4e373ee9b762398d54d7 is first bad commit
> commit 6b7b651055221127304a4e373ee9b762398d54d7
> Author: FUJITA Tomonori <tomof@acm.org>
> Date:   Mon Feb 4 22:27:55 2008 -0800
> 
>     iommu sg merging: add device_dma_parameters structure
> 
>     IOMMUs merges scatter/gather segments without considering a low level
>     driver's restrictions. The problem is that IOMMUs can't access to the
>     limitations because they are in request_queue.
> 
>     This patchset introduces a new structure, device_dma_parameters,
>     including dma information. A pointer to device_dma_parameters is added
>     to struct device. The bus specific structures (like pci_dev) includes
>     device_dma_parameters. Low level drivers can use dma_set_max_seg_size
>     to tell IOMMUs about the restrictions.
> 
>     We can move more dma stuff in struct device (like dma_mask) to struct
>     device_dma_parameters later (needs some cleanups before that).
> 
>     This includes patches for all the IOMMUs that could merge sg (x86_64,
>     ppc, IA64, alpha, sparc64, and parisc) though only the ppc patch was
>     tested. The patches for other IOMMUs are only compile tested.
> 
> $ gcc -v
> Using built-in specs.
> Target: i686-pc-linux-gnu
> Configured with: ../configure --prefix=/opt/gcc
> Thread model: posix
> gcc version 4.2.3
> 
> Config:
>
> ...
> 
> # CONFIG_DEBUG_BUGVERBOSE is not set
>

This one really should be enabled at all times, please.

Can you please set it and retry?
