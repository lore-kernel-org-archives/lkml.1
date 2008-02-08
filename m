Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYBHXcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYBHXcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbYBHXcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:32:22 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36455 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752136AbYBHXcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:32:21 -0500
Date: Fri, 8 Feb 2008 15:32:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: andrea@qumranet.com, holt@sgi.com, avi@qumranet.com, izike@qumranet.com,
       kvm-devel@lists.sourceforge.net, a.p.zijlstra@chello.nl,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, general@lists.openfabrics.org
Subject: Re: [patch 0/6] MMU Notifiers V6
In-Reply-To: <20080208142315.7fe4b95e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0802081528070.4036@schroedinger.engr.sgi.com>
References: <20080208220616.089936205@sgi.com> <20080208142315.7fe4b95e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, Andrew Morton wrote:

> What about ib_umem_get()?

Ok. It pins using an elevated refcount. Same as XPmem right now. With that 
we effectively pin a page (page migration will fail) but we will 
continually be reclaiming the page and may repeatedly try to move it. We 
have issues with XPmem causing too many pages to be pinned and thus the 
OOM getting into weird behavior modes (OOM or stop lru scanning due to 
all_reclaimable set).

An elevated refcount will also not be noticed by any of the schemes under 
consideration to improve LRU scanning performance.

 
