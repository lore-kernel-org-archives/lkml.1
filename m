Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbXHXQxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbXHXQxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758489AbXHXQxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:53:06 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2836 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbXHXQxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:53:04 -0400
Message-ID: <46CF0CCF.7010702@shadowen.org>
Date: Fri, 24 Aug 2007 17:52:31 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Mel Gorman <mel@skynet.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 Boot NUMA kernels on non-NUMA hardware with DISCONTIG
 memory model
References: <20070824162814.GD26374@skynet.ie> <20070824163521.GA16227@bingen.suse.de>
In-Reply-To: <20070824163521.GA16227@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This reserved portion of the KVA must be PMD aligned. 
> 
> Why do they need to be PMD aligned?  

That comes from the fact that the KVA in x86 has traditionally been
mapped with huge pages where at all possible, for performance reasons.
The purpose of the remap itself always has been performance based, we
are remapping node-local memory into KVA to hold the memmap in part to
exploit locality of process to its memory, and to in part to distribute
the load on the NUMA memory infrastructure by "striping" the storage.
As a result it makes sense to map these remapped areas with huge pages
also.  As is evidenced by the fact this bug is only coming to light now,
it is somewhat rare for the end of a NODE to be miss-aligned below the
huge page level (2/4MB).

-apw
