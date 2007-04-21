Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXDUBst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXDUBst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 21:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932203AbXDUBst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 21:48:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32769 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754042AbXDUBss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 21:48:48 -0400
Date: Fri, 20 Apr 2007 18:48:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ethan Solomita <solo@google.com>
cc: akpm@osdl.org, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
In-Reply-To: <46296ACD.3020402@google.com>
Message-ID: <Pine.LNX.4.64.0704201840200.13607@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
 <46019F67.3010300@google.com> <Pine.LNX.4.64.0703211428430.4832@schroedinger.engr.sgi.com>
 <4626CEDA.7050608@google.com> <Pine.LNX.4.64.0704181948260.8743@schroedinger.engr.sgi.com>
 <46296ACD.3020402@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Ethan Solomita wrote:

> cpuset_write_dirty_map.htm
> 
>    In __set_page_dirty_nobuffers() you always call cpuset_update_dirty_nodes()
> but in __set_page_dirty_buffers() you call it only if page->mapping is still
> set after locking. Is there a reason for the difference? Also a question not
> about your patch: why do those functions call __mark_inode_dirty() even if the
> dirty page has been truncated and mapping == NULL?

If page->mapping has been cleared then the page was removed from the 
mapping. __mark_inode_dirty just dirties the inode. If a truncation occurs 
then the inode was modified.

> cpuset_write_throttle.htm
> 
>    I noticed that several lines have leading spaces. I didn't check if other
> patches have the problem too.

Maybe download the patches? How did those strange .htm endings get 
appended to the patches?

>    In get_dirty_limits(), when cpusets are configd you don't subtract highmen
> the same way that is done without cpusets. Is this intentional?

That is something in flux upstream. Linus changed it recently. Do it one 
way or the other.

>    It seems that dirty_exceeded is still a global punishment across cpusets.
> Should it be addressed?

Sure. It would be best if you could place that somehow in a cpuset.

