Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbYH1RAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbYH1RAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYH1Q7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:59:54 -0400
Received: from mail.lang.hm ([64.81.33.126]:52605 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbYH1Q7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:59:54 -0400
Date: Thu, 28 Aug 2008 10:00:20 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: question about overcommit
Message-ID: <alpine.DEB.1.10.0808280952010.2713@asgard.lang.hm>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with overcommit enabled when a process forks the pages are marked COW and 
no new memory is allocated (cache and buffers are untouched)

when overcommit is disabled and a process forks new memory is allocated, 
but will this force cache and buffers to be thrown away (and possibly 
force stuff out to swap) even if the memory is never written to? or does 
the kernel still mark the pages COW, but somehow record that a chunk of 
virtual memory (ram + swap) has been allocated for this without actually 
affecting what's in ram?

my belief from watching the discussions is that it will evict things from 
ram to make space for the new allocation, and as a result running with 
overcommit disabled ends up wasting a noticable amount of ram. As a result 
I leave overcommit enabled and create swap space large enough to handle 
what I consider reasonable overloads (i.e. if I'm useing more swap than 
what's allocated the machine is slmost certinly thrashing so much as to be 
unusable)

but if I am wrong and the allocations actually can come from unused swap 
space without pushing anything out of ram, then the right thing to do is 
to disable overcommit and allocate a sizable chunk of swap space to get 
a similar result as with overcommit, but without any possibility of the 
OOM killer kicking in (at the cost that programs may fail memory 
allocations instead)

could someone please clarify this for me?

David Lang
