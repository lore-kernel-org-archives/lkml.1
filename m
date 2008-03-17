Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYCQR2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYCQR2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYCQR2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:28:14 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42662 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751759AbYCQR2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:28:13 -0400
Date: Mon, 17 Mar 2008 10:27:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205724940.3215.339.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803171025060.7359@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
  <1205463842.3215.188.camel@ymzhang>  <Pine.LNX.4.64.0803132328330.24204@schroedinger.engr.sgi.com>
  <1205478861.3215.279.camel@ymzhang>  <Pine.LNX.4.64.0803141356540.28115@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0803141713340.29413@schroedinger.engr.sgi.com>
 <1205724940.3215.339.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2008, Zhang, Yanmin wrote:

> There is no much help. In 2.6.25-rc5, REFILL means refill from c->page->freelist
> and another_slab. It's looks like its definition is confusing. In the case of
> hackbench, mostly, c->page->freelist is NULL.

REFILL means refilling the per cpu objects from the freelist of the 
per cpu slab page. That could be bad because it requires taking the slab 
lock on the slab page.

> Slab Perf Counter       Alloc     Free %Al %Fr
> --------------------------------------------------
> Fastpath             55883575  6130576  69   7
> Slowpath             24131134 73883818  30  92
> Page Alloc              84844    84788   0   0
> Add partial            270625 23860257   0  29
> Remove partial       24046290    84752  30   0

Hmmm... I was hoping that add/remove partial numbers would come down. Ok 
lets forget about the patch. Increasing min_objects does the trick.
