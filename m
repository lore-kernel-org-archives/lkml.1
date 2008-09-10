Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYIJObh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYIJObh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbYIJObU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:31:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60302 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYIJObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:31:18 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: some lock annotations for user copy paths
From: Andi Kleen <andi@firstfloor.org>
References: <20080910113717.GB16811@wotan.suse.de>
Date: Wed, 10 Sep 2008 16:31:15 +0200
In-Reply-To: <20080910113717.GB16811@wotan.suse.de> (Nick Piggin's message of "Wed, 10 Sep 2008 13:37:17 +0200")
Message-ID: <87od2wrs24.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:
>  int __copy_from_user(void *dst, const void __user *src, unsigned size)
>  {
>  	int ret = 0;
> +
> +	might_sleep();
> +	if (current->mm)
> +		might_lock_read(&current->mm->mmap_sem);

It would be nicer if you defined a standard function for this, e.g.
a might_page_fault(); 

This would also make it easier to potentially add more locks.

-Andi

-- 
ak@linux.intel.com
