Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbXK2DPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbXK2DPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 22:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXK2DPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 22:15:45 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54848 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241AbXK2DPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 22:15:44 -0500
Date: Thu, 29 Nov 2007 12:18:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH][for -mm] per-zone and reclaim enhancements for memory
 controller take 3 [3/10] per-zone active inactive counter
Message-Id: <20071129121834.c18ff796.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071129112406.c6820a5e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071127115525.e9779108.kamezawa.hiroyu@jp.fujitsu.com>
	<20071127120048.ef5f2005.kamezawa.hiroyu@jp.fujitsu.com>
	<1196284799.5318.34.camel@localhost>
	<20071129103702.cbc5cf73.kamezawa.hiroyu@jp.fujitsu.com>
	<20071129112406.c6820a5e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 11:24:06 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 29 Nov 2007 10:37:02 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Maybe zonelists of NODE_DATA() is not initialized. you are right.
> > I think N_HIGH_MEMORY will be suitable here...(I'll consider node-hotplug case later.)
> > 
> > Thank you for test!
> > 
> Could you try this ? 
> 
Sorry..this can be a workaround but I noticed I miss something..

ok, just use N_HIGH_MEMORY here and add comment for hotplugging support is not yet.

Christoph-san, Lee-san, could you confirm following ?

- when SLAB is used, kmalloc_node() against offline node will success.
- when SLUB is used, kmalloc_node() against offline node will panic.

Then, the caller should take care that node is online before kmalloc().

Regards,
-Kame 

