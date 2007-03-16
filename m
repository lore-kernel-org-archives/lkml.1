Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbXCPHpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbXCPHpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 03:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXCPHpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 03:45:16 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:37912 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbXCPHpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 03:45:15 -0400
Date: Fri, 16 Mar 2007 09:45:12 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] revoke: misc fixes
In-Reply-To: <45FA4984.9000506@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0703160943460.15253@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703160916430.14651@sbz-30.cs.Helsinki.FI>
 <45FA458C.8050605@yahoo.com.au> <Pine.LNX.4.64.0703160927240.14902@sbz-30.cs.Helsinki.FI>
 <45FA4984.9000506@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Fri, 16 Mar 2007, Nick Piggin wrote:
> Could you try something like walk the i_mmap lists to find mms with vmas that
> haven't need revoking, then each time you find one, take a ref on the mm, drop
> i_mmap_lock, take mmap_sem, and walk all its vmas looking for any that
> reference the inode?

Yes, that would work. What I am cooking up now is dropping 
->i_mmap_lock, restarting the scan after each revoke_vma() and skipping 
vmas that are VM_REVOKED.

			Pekka
