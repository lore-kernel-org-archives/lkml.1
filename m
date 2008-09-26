Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYIZKne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYIZKne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 06:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755237AbYIZKnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 06:43:21 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:49906 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023AbYIZKnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 06:43:19 -0400
Subject: Re: Populating multiple ptes at fault time
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Avi Kivity <avi@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Hugh Dickens <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <48DBD94A.50905@goop.org>
References: <48D142B2.3040607@goop.org> <48D17E75.80807@redhat.com>
	 <48D1851B.70703@goop.org> <48D18919.9060808@redhat.com>
	 <48D18C6B.5010407@goop.org> <48D2B970.7040903@redhat.com>
	 <48D2D3B2.10503@goop.org> <48D2E65A.6020004@redhat.com>
	 <48D2EBBB.205@goop.org> <48D2F05C.4040000@redhat.com>
	 <48D2F571.4010504@goop.org> <48DA333C.2050900@redhat.com>
	 <48DBD94A.50905@goop.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Fri, 26 Sep 2008 12:26:27 +0200
Message-Id: <1222424787.22679.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 11:32 -0700, Jeremy Fitzhardinge wrote:
> Very few places actually care about the state of the A/D bits; would it
> be expensive to make those places explicitly ask for synchronization
> before testing the bits (or alternatively, have an explicit query
> operation rather than just poking about in the ptes).  Martin, does this
> help with s390's per-page (vs per-pte) A/D state?

With the kvm support the situation on s390 recently has grown a tad more
complicated. We now have dirty bits in the per-page storage key and in
the pgste (page table entry extension) for the kvm guests. For the A/D
bits in the storage key the new pte operations won't help, for the kvm
related bits they could make a difference.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


