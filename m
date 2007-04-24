Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbXDXFNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbXDXFNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbXDXFNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:13:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXDXFNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:13:39 -0400
Message-ID: <462D91EA.7030003@redhat.com>
Date: Tue, 24 Apr 2007 01:13:14 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, shak <dshaks@redhat.com>,
       jakub@redhat.com, drepper@redhat.com
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE
References: <46247427.6000902@redhat.com>	<20070420135715.f6e8e091.akpm@linux-foundation.org>	<462932BE.4020005@redhat.com>	<20070420150618.179d31a4.akpm@linux-foundation.org>	<4629524C.5040302@redhat.com>	<462ACA40.8070407@yahoo.com.au>	<462B0156.9020407@redhat.com>	<462BFAF3.4040509@yahoo.com.au>	<462C2DC7.5070709@redhat.com>	<462C2F33.8090508@redhat.com>	<462C7A6F.9030905@redhat.com>	<462C88B1.8080906@yahoo.com.au>	<462C8B0A.8060801@redhat.com>	<462C8BFF.2050405@yahoo.com.au>	<462C8E1D.8000706@redhat.com>	<462D5A2E.5060908@yahoo.com.au>	<462D643C.5020709@redhat.com> <17965.35482.107374.228339@cargo.ozlabs.ibm.com>
In-Reply-To: <17965.35482.107374.228339@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Rik van Riel writes:
> 
>> I guess we'll need to call tlb_remove_tlb_entry() inside the
>> MADV_FREE code to keep powerpc happy.
> 
> I don't see why; once ptep_test_and_clear_young has returned, the
> entry in the hash table has already been removed. 

OK, so this one won't be necessary. Good to know that.

Andrew, it looks like things won't be that bad :)

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
