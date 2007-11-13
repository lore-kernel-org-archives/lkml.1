Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbXKMH72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbXKMH72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 02:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbXKMH7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 02:59:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbXKMH7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 02:59:19 -0500
Date: Mon, 12 Nov 2007 23:59:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Introduce ext4_find_next_bit
Message-Id: <20071112235910.35a635e4.akpm@linux-foundation.org>
In-Reply-To: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11903523063349-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 10:55:05 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> Also add generic_find_next_le_bit
> 
> This gets used by the ext4 multi block allocator patches.
> 

arm allmodconfig:

fs/ext4/mballoc.c: In function `ext4_mb_generate_buddy':
fs/ext4/mballoc.c:836: error: implicit declaration of function `ext2_find_next_bit'

This patch makes my head spin.

Why did we declare generic_find_next_le_bit() in
include/asm-powerpc/bitops.h (wrong) as well as in
include/asm-generic/bitops/le.h (presumably correct)?

Why is it touching a powerpc file and no any other architectures? 
Something screwed up in powerpc land?

And why did arm break?

Shudder.  Anyway, please fix, and if that fix requires that various
braindamaged be repaired, please repair the braindamage rather than going
along with it.

Thanks.

