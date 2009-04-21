Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZDUGiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZDUGiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbZDUGip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:38:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33491 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZDUGio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:38:44 -0400
Date: Tue, 21 Apr 2009 15:33:37 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 03/25] Do not check NUMA node ID when the caller knows the node is valid
Message-ID: <20090421063337.GB15167@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mel Gorman <mel@csn.ul.ie>,
	Linux Memory Management List <linux-mm@kvack.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Christoph Lameter <cl@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lin Ming <ming.m.lin@intel.com>,
	Zhang Yanmin <yanmin_zhang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Andrew Morton <akpm@linux-foundation.org>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-4-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240266011-11140-4-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 11:19:49PM +0100, Mel Gorman wrote:
> Callers of alloc_pages_node() can optionally specify -1 as a node to mean
> "allocate from the current node". However, a number of the callers in fast
> paths know for a fact their node is valid. To avoid a comparison and branch,
> this patch adds alloc_pages_exact_node() that only checks the nid with
> VM_BUG_ON(). Callers that know their node is valid are then converted.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

For the SLOB NUMA bits:

Acked-by: Paul Mundt <lethal@linux-sh.org>
