Return-Path: <linux-kernel-owner+w=401wt.eu-S1422854AbXCWMe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422854AbXCWMe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 08:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422847AbXCWMe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 08:34:27 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:48495 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422854AbXCWMe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 08:34:27 -0400
Date: Fri, 23 Mar 2007 12:15:12 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <christoph@lameter.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: [RFC] NUMA : could we introduce virt_to_nid() ?
Message-Id: <20070323121512.c287ddef.dada1@cosmosbay.com>
In-Reply-To: <20070321160929.GB25583@one.firstfloor.org>
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	<84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
	<Pine.LNX.4.64.0703210742080.1573@graphe.net>
	<Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
	<20070321160929.GB25583@one.firstfloor.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi

Checking Christoph quicklist implementation, I found the same cache miss in free() than SLAB has.

/* common implementation *
int virt_to_nid(const void *addr)
{
	struct page *page = virt_to_page(addr); 
	return page_to_nid(page);
}

On some platforms (x86_64 for example), could we have a better implementation, not accessing struct page, but using phys_to_nid() ?

Thank you
