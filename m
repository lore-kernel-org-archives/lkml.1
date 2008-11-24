Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbYKXTPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbYKXTPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYKXTPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:15:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:42981 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYKXTPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:15:44 -0500
Subject: Re: [patch 2/2] mm: add dirty_background_bytes and dirty_bytes
 sysctls
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Nov 2008 20:15:32 +0100
Message-Id: <1227554132.4259.535.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-11-23 at 10:55 -0800, David Rientjes wrote:
> This change introduces two new sysctls to /proc/sys/vm:
> dirty_background_bytes and dirty_bytes.
> 
> dirty_background_bytes is the counterpart to dirty_background_ratio and
> dirty_bytes is the counterpart to dirty_ratio.
> 
> With growing memory capacities of individual machines, it's no longer
> sufficient to specify dirty thresholds as a percentage of the amount of
> dirtyable memory over the entire system.
> 
> dirty_background_bytes and dirty_bytes specify quantities of memory, in
> bytes, that represent the dirty limits for the entire system.  If either
> of these values is set, its value represents the amount of dirty memory
> that is needed to commence either background or direct writeback.
> 
> When a `bytes' or `ratio' file is written, its counterpart becomes a
> function of the written value.  For example, if dirty_bytes is written to
> be 8096, 8K of memory is required to commence direct writeback.
> dirty_ratio is then functionally equivalent to 8K / the amount of
> dirtyable memory:
> 
> 	dirtyable_memory = free pages + mapped pages + file cache
> 
> 	dirty_background_bytes = dirty_background_ratio * dirtyable_memory
> 		-or-
> 	dirty_background_ratio = dirty_background_bytes / dirtyable_memory
> 
> 		AND
> 
> 	dirty_bytes = dirty_ratio * dirtyable_memory
> 		-or-
> 	dirty_ratio = dirty_bytes / dirtyable_memory
> 
> Only one of dirty_background_bytes and dirty_background_ratio may be
> specified at a time, and only one of dirty_bytes and dirty_ratio may be
> specified.  When one sysctl is written, the other appears as 0 when read.
> 
> The `bytes' files operate on a page size granularity since dirty limits
> are compared with ZVC values, which are in page units.
> 
> Prior to this change, the minimum dirty_ratio was 5 as implemented by
> get_dirty_limits() although /proc/sys/vm/dirty_ratio would show any user
> written value between 0 and 100.  This restriction is maintained, but
> dirty_bytes has a lower limit of only one page.
> 
> Also prior to this change, the dirty_background_ratio could not equal or
> exceed dirty_ratio.  This restriction is maintained in addition to
> restricting dirty_background_bytes.  If either background threshold equals
> or exceeds that of the dirty threshold, it is implicitly set to half the
> dirty threshold.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

I don't really like the dual interface, but I guess given the
restrictions this is the best one can do... So

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

