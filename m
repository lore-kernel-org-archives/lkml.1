Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYEHBMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYEHBMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYEHBMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:12:40 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45269 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751285AbYEHBMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:12:38 -0400
Date: Wed, 7 May 2008 18:12:32 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrea Arcangeli <andrea@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <alpine.LFD.1.10.0805071757520.3024@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805071809170.14935@schroedinger.engr.sgi.com>
References: <6b384bb988786aa78ef0.1210170958@duo.random>
 <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org>
 <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org>
 <20080507222205.GC8276@duo.random> <20080507153103.237ea5b6.akpm@linux-foundation.org>
 <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org>
 <20080507233953.GM8276@duo.random> <alpine.LFD.1.10.0805071757520.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Linus Torvalds wrote:

> and you're now done. You have your "mm_lock()" (which still needs to be 
> renamed - it should be a "mmu_notifier_lock()" or something like that), 
> but you don't need the insane sorting. At most you apparently need a way 
> to recognize duplicates (so that you don't deadlock on yourself), which 
> looks like a simple bit-per-vma.

Andrea's mm_lock could have wider impact. It is the first effective 
way that I have seen of temporarily holding off reclaim from an address 
space. It sure is a brute force approach.

