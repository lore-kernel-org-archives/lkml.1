Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYICWKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYICWKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYICWJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:09:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33658 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYICWJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:09:54 -0400
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, tony.luck@intel.com
Subject: Re: [PATCH] swiotlb: fix dma_alloc_coherent allocation failures with swiotlb
From: Andi Kleen <andi@firstfloor.org>
References: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com>
Date: Thu, 04 Sep 2008 00:09:51 +0200
In-Reply-To: <1220454224-25985-1-git-send-email-joerg.roedel@amd.com> (Joerg Roedel's message of "Wed, 3 Sep 2008 17:03:44 +0200")
Message-ID: <877i9sx4nk.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joerg.roedel@amd.com> writes:

> The SWIOTLB version of dma_alloc_coherent allocates all memory with
> GFP_DMA unconditionally. This leads sometimes unnecessary to allocation
> failures. This patch makes the allocation strategy to use the DMA32 zone
> first if this is possible. The changes are boot tested on AMD64 and
> compile tested for i386 and IA64.

The high level dma_alloc_coherent() does that anyways.

The swiotlb fallback really should only allocate from the swiotlb,
nowhere else.

-Andi
