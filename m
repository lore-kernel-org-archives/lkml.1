Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZFBN7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZFBN7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbZFBN7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:59:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34847 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbZFBN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:59:30 -0400
Date: Tue, 2 Jun 2009 16:06:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602140639.GQ1065@one.firstfloor.org>
References: <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de> <20090601183225.GS1065@one.firstfloor.org> <20090602120042.GB1392@wotan.suse.de> <20090602124757.GG1065@one.firstfloor.org> <20090602125713.GG1392@wotan.suse.de> <20090602132538.GK1065@one.firstfloor.org> <20090602132441.GC6262@wotan.suse.de> <20090602134126.GM1065@one.firstfloor.org> <20090602135324.GB21338@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602135324.GB21338@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Ok you're right. That one is not needed. I will remove it.
> 
> No! Please read the comment. In fact __remove_from_page_cache() has a
> 
>                 BUG_ON(page_mapped(page));
> 
> Or, at least correct that BUG_ON() line together.

Yes, but we already have them unmapped earlier and the poison check
in the page fault handler should prevent remapping.

So it really should not happen and if it happened we would deserve
the BUG.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
