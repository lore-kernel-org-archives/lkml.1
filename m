Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbZFSWaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbZFSWaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZFSW35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:29:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:35171 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbZFSW34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:29:56 -0400
Subject: Re: [PowerPC] 2.6.30-git14 boot failure with SLAB
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linuxppc-dev@ozlabs.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A3BC57B.8000408@in.ibm.com>
References: <4A3B615F.8090504@in.ibm.com>  <4A3BC57B.8000408@in.ibm.com>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 08:29:40 +1000
Message-Id: <1245450580.16880.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 22:36 +0530, Sachin Sant wrote:
> The offending commit seems to be
> c868d550115b9ccc0027c67265b9520790f05601.
> mm: Move pgtable_cache_init() earlier
> 
> If i revert this commit, the machine boots fine.

That is strange. If I revert that commit, I get breakages on machines
here. It would be interesting to understand what the problem is here,
as we -do- use that kmem cache for allocating page tables, so we do
need it initialized that early. (IE, we can't allow vmalloc for example
to be called before the page table caches are initialized).

This will need more debugging and understanding as to why it hangs.

Cheers,
Ben.


