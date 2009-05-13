Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbZEMKKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbZEMKKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922AbZEMKJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:09:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZEMKJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:09:58 -0400
Message-ID: <4A0A9C70.6090803@novell.com>
Date: Wed, 13 May 2009 19:09:52 +0900
From: Tejun Heo <teheo@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: remap allocator for per-CPU memory
References: <4A09B23B02000078000007F1@vpn.id2.novell.com> <4A09991E.9010903@kernel.org>
In-Reply-To: <4A09991E.9010903@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jan Beulich wrote:
>> Didn't the addition of this allocator introduce another case that
>> needs special treatment in pageattr.c? Since large pages are used
>> for mapping the allocated memory, but only part of the initially
>> allocated large pages are actually retained, there's now the
>> potential for TLB aliases with different cache attributes for those
>> parts of these pages that get passed back through free_bootmem().
> 
> Hmmm.... yes, the large page mapping and the returned part of it would
> alias each other.  What changes should be made for it?  Dunno much
> about how pageattr works.

Okay, just glanced over the pageattr code.  I don't think we need any
special provisions for this as long as the TLB is fine with having
overlapping PMD and PTE mappings with different attributes (please
note that these two mappings aren't occupying the same linear
addresses - they're aliases).  This is allowed, right?

Thanks.

-- 
tejun
