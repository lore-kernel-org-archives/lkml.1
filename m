Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbXEPAiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbXEPAiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760024AbXEPAiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:38:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47595
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1759010AbXEPAiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:38:16 -0400
Date: Tue, 15 May 2007 17:38:20 -0700 (PDT)
Message-Id: <20070515.173820.101498227.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: clameter@sgi.com, mroos@linux.ee, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070515172957.02d80d51.akpm@linux-foundation.org>
References: <20070515165636.5057456e.akpm@linux-foundation.org>
	<20070515.171447.83623268.davem@davemloft.net>
	<20070515172957.02d80d51.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 15 May 2007 17:29:57 -0700

> This:
> 
> struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1] __cacheline_aligned;
> 
> is still there.

My bad, we tried using min_t() and that's what caused the problems,
that's why we open-coded the macro like it is now :-)
