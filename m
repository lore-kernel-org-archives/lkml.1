Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbXJLEel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbXJLEel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbXJLEed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:34:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57236 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbXJLEec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:34:32 -0400
Date: Fri, 12 Oct 2007 13:33:11 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [Patch 001/002] Make description of memory hotplug notifier in document
Cc: Andrew Morton <akpm@osdl.org>,
       Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0710112110590.1882@schroedinger.engr.sgi.com>
References: <20071012111830.B997.Y-GOTO@jp.fujitsu.com> <Pine.LNX.4.64.0710112110590.1882@schroedinger.engr.sgi.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20071012133129.B9A3.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Looks good. Some suggestions on improving the wording.

Thanks! I'll fix them.

Bye.

> 
> On Fri, 12 Oct 2007, Yasunori Goto wrote:
> 
> > +MEMORY_GOING_ONLINE
> > +  This is notified before memory online. If some structures must be prepared
> > +  for new memory, it should be done at this event's callback.
> > +  The new onlining memory can't be used yet.
> 
> Generated before new memory becomes available in order to be able to 
> prepare subsystems to handle memory. The page allocator is still unable
> to allocate from the new memory.
> 
> > +MEMORY_CANCEL_ONLINE
> > +  If memory online fails, this event is notified for rollback of setting at
> > +  MEMORY_GOING_ONLINE.
> > +  (Currently, this event is notified only the case which a callback routine
> > +   of MEMORY_GOING_ONLINE fails).
> 
> Generated if MEMORY_GOING_ONLINE fails.
> 
> > +MEMORY_ONLINE
> > +  This event is called when memory online is completed. The page allocator uses
> > +  new memory area before this notification. In other words, callback routine
> > +  use new memory area via page allocator.
> > +  The failures of callbacks of this notification will be ignored.
> 
> Generated when memory has succesfully brought online. The callback may 
> allocate from the new memory.
> 
> > +MEMORY_GOING_OFFLINE
> > +  This is notified on halfway of memory offline. The offlining pages are
> > +  isolated. In other words, the page allocater doesn't allocate new pages from
> > +  offlining memory area at this time. If callback routine freed some pages,
> > +  they are not used by the page allocator.
> > +  This is good place for shrinking cache. (If possible, it is desirable to
> > +  migrate to other area.)
> 
> Generated to begin the process of offlining memory. Allocations are no 
> longer possible from the memory but some of the memory to be offlined
> is still in use. The callback can be used to free memory known to a 
> subsystem from the indicated node.
> 
> > +MEMORY_CANCEL_OFFLINE
> > +  If memory offline fails, this event is notified for rollback against
> > +  MEMORY_GOING_OFFLINE. The page allocator will use target memory area after
> > +  this callback again.
> 
> Generated if MEMORY_GOING_OFFLINE fails. Memory is available again from 
> the node that we attempted to offline.
> 
> > + +MEMORY_OFFLINE
> 
> Generated after offlining memory is complete.

-- 
Yasunori Goto 


