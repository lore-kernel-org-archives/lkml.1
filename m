Return-Path: <linux-kernel-owner+w=401wt.eu-S1422686AbXDCUJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422686AbXDCUJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422688AbXDCUJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:09:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60108 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422686AbXDCUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:09:38 -0400
Date: Tue, 3 Apr 2007 22:09:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ulrich Drepper <drepper@redhat.com>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
Message-ID: <20070403200936.GA25541@one.firstfloor.org>
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403125903.3e8577f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It might, a bit.  Both mmap() and mprotect() currently take mmap_sem() for
> writing.  If we're careful, we could probably arrange for MADV_ULRICH to
> take it for reading, which will help a little bit, hopefully.

The cache line bounces would be still there. Not sure that would help MySQL
all that much. 

Besides if the down_write is the real problem one could convert 
the code for all cases over to optimistic locking assuming most calls 
don't merge.

-Andi
