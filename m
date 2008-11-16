Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbYKPM6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbYKPM6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKPM6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:58:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:55528 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbYKPM6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:58:32 -0500
Subject: Re: [PATCH] ext2/ext3: allocate ->s_blockgroup_lock separately to
	avoid wasting space
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, cl@linux-foundation.org, mpm@selenic.com,
       eduard.munteanu@linux360.ro
In-Reply-To: <Pine.LNX.4.64.0811141115100.29826@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0811141115100.29826@melkki.cs.Helsinki.FI>
Content-Type: text/plain
Date: Sun, 16 Nov 2008 13:58:09 +0100
Message-Id: <1226840289.8172.8.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 11:17 +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> As spotted by kmemtrace, struct ext2_sb_info is 17024 bytes and ext3_sb_info is
> 17152 bytes on 64-bit which makes them a very bad fit for SLAB allocators. In
> fact, both allocations are round up to the next available page size of 
> order 3 which is 32 KB.
> 
> The culprit if the wasted memory is the ->s_blockgroup_lock which can be as big
> as 16 KB when CONFIG_NR_CPUS is set to 32. As struct blockgroup_lock is a
> perfect fit for order 2 page in the worst case, allocate ->s_blockgroup_lock
> separately to avoid wasting space.

And here I was thinking that NR_CPUS=4096 is currently our worst
case ;-)

