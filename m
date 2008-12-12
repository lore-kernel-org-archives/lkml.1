Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbYLLNrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbYLLNrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:47:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758218AbYLLNri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:47:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36468 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215AbYLLNrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:47:37 -0500
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm 1/5] nilfs2: fix problems of memory allocation in ioctl
From: Andi Kleen <andi@firstfloor.org>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Date: Fri, 12 Dec 2008 14:47:58 +0100
In-Reply-To: <1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp> (Ryusuke Konishi's message of "Fri, 12 Dec 2008 14:16:57 +0900")
Message-ID: <871vwdcxo1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> writes:

> The current memory copy function of nilfs2 ioctl has following
> problems:

Wouldn't it be easier/faster/more reliable to just use vmalloc for
those allocations?  The only reason to use kmalloc for such large
allocations would be if you want to do direct DMA (but even there are
ways to do this using virtual allocations and scatter-gather)

-Andi
>

-- 
ak@linux.intel.com
