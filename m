Return-Path: <linux-kernel-owner+w=401wt.eu-S1030632AbXEALxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030632AbXEALxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 07:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031663AbXEALxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 07:53:20 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:46985 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030668AbXEALxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 07:53:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=cmpvD9tVVRuJEw97Xg8iH9Dsis7iMco9uoU8topoiePJ/+3oJ5TF+lszsNRWD6/J3MIsiZGXGtUvYYnRy7wevoGf7jZKihYB5zV4vQkO9AOtXXyFRhQDgJCS10VxxfQkyLKCQy1qBEHfkVgD+i3p+ogVXO6vWx5o7h3FLhrvkzM=  ;
X-YMail-OSG: mglx7pIVM1neDtgx3ZoVHsO8w5qrqrUyV2yJ9DJ5xoedR0LcY7el1qm3y_E0se9FV926E5maSQ--
Message-ID: <46372A12.9080802@yahoo.com.au>
Date: Tue, 01 May 2007 21:52:50 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rohit Seth <rohitseth@google.com>
CC: "'Hugh Dickins'" <hugh@veritas.com>,
       "'Mike Stroyan'" <mike.stroyan@hp.com>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'Luck, Tony'" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
References: <200704281817.l3SIHu0P001764@smtp.corp.google.com>
In-Reply-To: <200704281817.l3SIHu0P001764@smtp.corp.google.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rohit Seth wrote:

>>and 
>>it's only interested when it's executable i.e. "lazy_mmu_prot_update"
>>is a name concealing some overdesign.
> 
> 
> You are right that ia64 is only interested in whne the execute permissions
> kick in (and FWIW ia64 used to use update_mmu_cache API to do what it is now
> doing lazy_mmu_prot_update).  Though the idea was to design an API that any
> arch can use to know when ever there is change in protections on a mapping.

What I think what we should do is audit flush_icache_page coverage, and
convert ia64 to use that (because it needs this to happen _before_ the
pte is set).

All we should need to do is add a pte argument to flush_icache, and it
should be possible to do what ia64 wants, and we can remove
lazy_mmu_prot_update (or at least rename it to something like
flush_icache_page_chprot and move it to the normal flush_icache_page
position above set_pte if not all architectures want their
flush_icache_page called at protection change time).

-- 
SUSE Labs, Novell Inc.
