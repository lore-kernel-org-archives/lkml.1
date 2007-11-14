Return-Path: <linux-kernel-owner+w=401wt.eu-S1763378AbXKNBGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763378AbXKNBGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 20:06:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764167AbXKNBGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 20:06:31 -0500
Received: from mx1.suse.de ([195.135.220.2]:43838 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764163AbXKNBG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 20:06:29 -0500
To: David Miller <davem@davemloft.net>
Cc: clameter@sgi.com, akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: Andi Kleen <andi@firstfloor.org>
References: <20071106195144.983665861@sgi.com>
	<20071106195157.878563669@sgi.com>
	<20071113.031510.151440585.davem@davemloft.net>
Date: Wed, 14 Nov 2007 02:06:28 +0100
In-Reply-To: <20071113.031510.151440585.davem@davemloft.net> (David Miller's message of "Tue\, 13 Nov 2007 03\:15\:10 -0800 \(PST\)")
Message-ID: <p73wssly6sr.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
>
> The problem is that for the non-virtualized case this patch bloats up
> the BSS section to be more than 8MB in size.  Sparc64 kernel images
> cannot be more than 8MB in size total due to various boot loader and
> firmware limitations.

I recently ran into a similar problem with x86-64 and large BSS from
lockdep conflicting with a 16MB kdump kernel. Solution was to do
another early allocator before bootmem and then move the tables into
there.

-Andi

