Return-Path: <linux-kernel-owner+w=401wt.eu-S1754577AbXDXEoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbXDXEoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbXDXEoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:44:04 -0400
Received: from ozlabs.org ([203.10.76.45]:54454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574AbXDXEnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:43:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17965.35482.107374.228339@cargo.ozlabs.ibm.com>
Date: Tue, 24 Apr 2007 14:42:02 +1000
From: Paul Mackerras <paulus@samba.org>
To: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
In-Reply-To: <462D643C.5020709@redhat.com>
References: <46247427.6000902@redhat.com>
	<20070420135715.f6e8e091.akpm@linux-foundation.org>
	<462932BE.4020005@redhat.com>
	<20070420150618.179d31a4.akpm@linux-foundation.org>
	<4629524C.5040302@redhat.com>
	<462ACA40.8070407@yahoo.com.au>
	<462B0156.9020407@redhat.com>
	<462BFAF3.4040509@yahoo.com.au>
	<462C2DC7.5070709@redhat.com>
	<462C2F33.8090508@redhat.com>
	<462C7A6F.9030905@redhat.com>
	<462C88B1.8080906@yahoo.com.au>
	<462C8B0A.8060801@redhat.com>
	<462C8BFF.2050405@yahoo.com.au>
	<462C8E1D.8000706@redhat.com>
	<462D5A2E.5060908@yahoo.com.au>
	<462D643C.5020709@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel writes:

> I guess we'll need to call tlb_remove_tlb_entry() inside the
> MADV_FREE code to keep powerpc happy.

I don't see why; once ptep_test_and_clear_young has returned, the
entry in the hash table has already been removed.  Adding the
tlb_remove_tlb_entry call certainly won't do anything on 64-bit
powerpc, since it expands to do {} while (0) there, and in fact it
won't do anything on 32-bit powerpc either.

Paul.
