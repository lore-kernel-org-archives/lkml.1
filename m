Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXC0OCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXC0OCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 10:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753869AbXC0OCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 10:02:13 -0400
Received: from mail.suse.de ([195.135.220.2]:50687 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859AbXC0OCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 10:02:12 -0400
To: "Ken Chen" <kenchen@google.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 27 Mar 2007 17:01:01 +0200
In-Reply-To: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com>
Message-ID: <p737it2689e.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Ken Chen" <kenchen@google.com> writes:

> It is really sad that we always call kmap and friends for every pipe
> buffer page on 64-bit arch that doesn't use HIGHMEM, or on
> configuration that doesn't turn on HIGHMEM.
> 
> The effect of calling kmap* is visible in the execution profile when
> pipe code is being stressed.  It is especially true on amd's x86-64
> platform where kmap() has to traverse through numa node index
> calculation in order to convert struct page * to kernel virtual
> address.  

What is the problem? You have cache misses on the the hash table
or are the instructions really an issue on a modern CPU?

e.g. i out of lined virt_to_page to save space, but it could be probably
inlined again if it was severly time critical. 

> +
> +#ifdef CONFIG_HIGHMEM
> +#define pipe_kmap		kmap
> +#define pipe_kmap_atomic	kmap_atomic

I think it would be better to have a somewhat generic kmap_caching() 
or similar interface that could be used by more subsystems.

-Andi

