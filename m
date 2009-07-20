Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZGTKLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZGTKLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 06:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZGTKLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 06:11:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:42388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZGTKLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 06:11:13 -0400
Subject: Re: [RFC/PATCH] mm: Pass virtual address to
 [__]p{te,ud,md}_free_tlb()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management <linux-mm@kvack.org>,
       Linux-Arch <linux-arch@vger.kernel.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Hugh Dickins <hugh@tiscali.co.uk>
In-Reply-To: <20090720081054.GH7298@wotan.suse.de>
References: <20090715074952.A36C7DDDB2@ozlabs.org>
	 <20090715135620.GD7298@wotan.suse.de> <1247709255.27937.5.camel@pasglop>
	 <20090720081054.GH7298@wotan.suse.de>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 20:00:41 +1000
Message-Id: <1248084041.30899.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 10:10 +0200, Nick Piggin wrote:
> 
> Maybe I don't understand your description correctly. The TLB contains
> PMDs, but you say the HW still logically performs another translation
> step using entries in the PMD pages? If I understand that correctly,
> then generic mm does not actually care and would logically fit better
> if those entries were "linux ptes". 

They are :-)

> The pte invalidation routines
> give the virtual address, which you could use to invalidate the TLB.

For PTEs, yes, but not for those PMD entries. IE. I need the virtual
address when destroying PMDs so that I can invalidate those "indirect"
pages. PTEs are already taken care of by existing mechanisms.

Cheers,
Ben.
 

