Return-Path: <linux-kernel-owner+w=401wt.eu-S1760742AbXKNEQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760742AbXKNEQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbXKNEP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:15:57 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46391 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755775AbXKNEP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:15:56 -0500
Date: Tue, 13 Nov 2007 20:15:55 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com, schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <p73wssly6sr.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0711132011060.7528@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com> <20071106195157.878563669@sgi.com>
 <20071113.031510.151440585.davem@davemloft.net> <p73wssly6sr.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm.. I have v2 in preparation here that puts the pda and the per cpu 
data into the cpu_alloc area. Thus gs: can be used to access all per cpu 
data.

Any ideas how to abstract out the pda operations? Wasnt local_t supposed 
to be able to do atomic ops on cpu data? Is there an segment register 
version of local_t? I want also to have cmpxchg xchg etc that are all 
atomic without requiring any interrupt disable or preempt disable.

cpu_alloc allows pointer arithmetic on cpu area pointers. The segment 
prefix can then be used to select the appropriate area.

Guess I need also to add an arch configuration guide to V2 as well so that 
the other arches can do similar tricks and emphasize that the static 
default that requires bss is only suitable for small systems.
