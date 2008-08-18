Return-Path: <linux-kernel-owner+w=401wt.eu-S1764122AbYHRTQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764122AbYHRTQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYHRTQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:16:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46397 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754876AbYHRTP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:15:59 -0400
Message-ID: <48A9CA10.80500@linux-foundation.org>
Date: Mon, 18 Aug 2008 14:14:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Adam Litke <agl@us.ibm.com>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       nacc <nacc@linux.vnet.ibm.com>, apw <apw@shadowen.org>,
       agl <agl@linux.vnet.ibm.com>
Subject: Re: [BUG] __GFP_THISNODE is not always honored
References: <1218837685.12953.11.camel@localhost.localdomain> <20080818105918.GD32113@csn.ul.ie>
In-Reply-To: <20080818105918.GD32113@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> That's bad in itself and has wider reaching consequences than hugetlb
> getting its counters wrong. I believe SLUB depends on __GFP_THISNODE
> being obeyed for example. Can you boot the machine in question with
> mminit_loglevel=4 and loglevel=8 set on the command line and send me the
> dmesg please? It should output the zonelists and I might be able to
> figure out what's going wrong. Thanks

Its SLAB depends on it and will corrupt data if the wrong node is returned.
SLAB has BUG_ONs that should trigger if anything like that occurs.


> This will mask the bug for hugetlb but I wonder if this should be a
> VM_BUG_ON(page_to_nid(page) != nid) ?

Right.
