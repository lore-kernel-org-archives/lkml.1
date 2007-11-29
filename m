Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbXK2D0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbXK2D0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 22:26:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbXK2D0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 22:26:31 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45180 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752722AbXK2D0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 22:26:31 -0500
Date: Wed, 28 Nov 2007 19:26:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [3/10] per-zone active inactive counter
In-Reply-To: <20071129121834.c18ff796.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0711281924580.20367@schroedinger.engr.sgi.com>
References: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
 <20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
 <1196284799.5318.34.camel@localhost> <20071129103702.cbc5cf73.kamezawa.hiroyu@jp.fujitsu.com>
 <20071129112406.c6820a5e.kamezawa.hiroyu@jp.fujitsu.com>
 <20071129121834.c18ff796.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, KAMEZAWA Hiroyuki wrote:

> ok, just use N_HIGH_MEMORY here and add comment for hotplugging support is not yet.
> 
> Christoph-san, Lee-san, could you confirm following ?
> 
> - when SLAB is used, kmalloc_node() against offline node will success.
> - when SLUB is used, kmalloc_node() against offline node will panic.
> 
> Then, the caller should take care that node is online before kmalloc().

Hmmmm... An offline node implies that the per node structure does not 
exist. SLAB should fail too. If there is something wrong with the allocs 
then its likely a difference in the way hotplug was put into SLAB and 
SLUB.


