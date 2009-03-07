Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZCGQyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZCGQyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 11:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbZCGQyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 11:54:17 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:40474 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZCGQyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 11:54:16 -0500
X-IronPort-AV: E=Sophos;i="4.38,319,1233532800"; 
   d="scan'208";a="66386858"
From: Roland Dreier <rdreier@cisco.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
       adobriyan@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -v2] memdup_user(): introduce
References: <49B0CAEC.80801@cn.fujitsu.com>
	<20090306082056.GB3450@x200.localdomain>
	<49B0DE89.9000401@cn.fujitsu.com>
	<20090306003900.a031a914.akpm@linux-foundation.org>
	<49B0E67C.2090404@cn.fujitsu.com>
	<20090306011548.ffdf9cbc.akpm@linux-foundation.org>
	<49B0F1B9.1080903@cn.fujitsu.com>
	<20090306150335.c512c1b6.akpm@linux-foundation.org>
	<20090307084805.7cf3d574@infradead.org>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 07 Mar 2009 08:54:14 -0800
In-Reply-To: <20090307084805.7cf3d574@infradead.org> (Arjan van de Ven's
	message of "Sat, 7 Mar 2009 08:48:05 -0800")
Message-ID: <adaeix9ff49.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Mar 2009 16:54:14.0831 (UTC) FILETIME=[58CF4BF0:01C99F45]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I would like to question the use of the gfp argument here;
 > copy_from_user sleeps, so you can't use GFP_ATOMIC anyway.
 > You can't use GFP_NOFS etc, because the pagefault path will happily do
 > things that are equivalent, if not identical, to GFP_KERNEL.

That's a convincing argument, and furthermore, strndup_user() does not
take a gfp parameter, so interface consistency also argues that the
function prototype should just be

void *memdup_user(const void __user *src, size_t len);

(By the way, the len parameter of strndup_user() is declared as long,
which seems strange, since it matches neither the userspace strndup()
nor the kernel kstrndup(), which both use size_t.  So using size_t for
memdup_user() and possibly fixing strndup_user() to use size_t as well
seems like the sanest thing)

 - R.


