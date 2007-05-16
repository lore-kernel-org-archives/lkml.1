Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbXEPAls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbXEPAls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759664AbXEPAlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:41:40 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:37435 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757461AbXEPAlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:41:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=qyFsOftAoJRangcwCGRxMFPlXRbZE38IcGolhi5eLJjCbTgIVUyIUpC0mOyKqfqnbTGgcQ5CfhukH6LvUzs9ycC0nkkHz3PBpcP36QPt7x84Ofu0zQxgN2633vIOs4qJDtOhO+9ZbKlbvr1nVHixTFHlAKwraf7DkGuEWeB2e1k=  ;
X-YMail-OSG: oDnJPW4VM1mVVFkJVqh8SSGhC3xV4ne7IuFPhUa3hhrj.3fjw__ahCH6tzG6jcMwQHCiMVDLzw--
Message-ID: <464A533B.8040507@yahoo.com.au>
Date: Wed, 16 May 2007 10:41:31 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com>	<20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com> <20070515144007.f87d9be5.akpm@linux-foundation.org>
In-Reply-To: <20070515144007.f87d9be5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 15 May 2007 16:52:31 +0100
> David Howells <dhowells@redhat.com> wrote:
> 
> 
>>Implement shared-writable mmap for AFS.
> 
> 
> This blows up in -mm:
> 
> fs/afs/file.c:59: error: 'filemap_nopage' undeclared here (not in a function)
> fs/afs/file.c:60: error: unknown field 'populate' specified in initializer
> fs/afs/file.c:60: error: 'filemap_populate' undeclared here (not in a function)
> 
> because Nick went and renamed half the VM and deleted the other half.

And page_mkwrite is next ;)


> I need to work out what to do with
> 
> mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
> mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
> mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
> mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
> mm-merge-nopfn-into-fault.patch
> convert-hugetlbfs-to-use-vm_ops-fault.patch
> mm-remove-legacy-cruft.patch
> mm-debug-check-for-the-fault-vs-invalidate-race.patch
> mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
> 
> Probably merge them, I guess.  Hugh had concerns, I think over small
> additional overhead from the lock_page()?

Yes he did. It seems to only be noticable in microbenchmarks. In my opinion
not enough to withhold pagecache corruption bug fixes.

Still, I have some lock_page speedup work that eliminates that regression
anyway.

However, Hugh hasn't exactly said yes or no yet...

-- 
SUSE Labs, Novell Inc.
