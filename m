Return-Path: <linux-kernel-owner+w=401wt.eu-S1762578AbXJYXhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762578AbXJYXhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbXJYXhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:37:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34042 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754036AbXJYXhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:37:31 -0400
Date: Thu, 25 Oct 2007 16:37:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, David Rientjes wrote:

> Adds a new 'interleave_over_allowed' option to cpusets.
> 
> When a task with an MPOL_INTERLEAVE memory policy is attached to a cpuset
> with this option set, the interleaved nodemask becomes the cpuset's
> mems_allowed.  When the cpuset's mems_allowed changes, the interleaved
> nodemask for all tasks with MPOL_INTERLEAVE memory policies is also
> updated to be the new mems_allowed nodemask.
> 
> This allows applications to specify that they want to interleave over all
> nodes that they are allowed to access.  This set of nodes can be changed
> at any time via the cpuset interface and each individual memory policy is
> updated to reflect the changes for all attached tasks when this option is
> set.

More interactions between cpusets and memory policies. We have to be 
careful here to keep clean semantics.

Isnt it a bit surprising for an application that has set up a custom 
MPOL_INTERLEAVE policy if the nodes suddenly change because of a cpuset or 
mems_allowed change?


