Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbXJZVF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbXJZVF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbXJZVFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:05:46 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:47076 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751781AbXJZVFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:05:45 -0400
Date: Fri, 26 Oct 2007 14:05:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Rientjes <rientjes@google.com>
cc: Paul Jackson <pj@sgi.com>, Lee.Schermerhorn@hp.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0710261357370.17483@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
 <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
 <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
 <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, David Rientjes wrote:

> Well, passing a single node to set_mempolicy() for MPOL_INTERLEAVE doesn't 
> make a whole lot of sense in the first place.  I prefer your solution of 
> allowing set_mempolicy(MPOL_INTERLEAVE, NODE_MASK_ALL) to mean "interleave 
> me over everything I'm allowed to access."  NODE_MASK_ALL would be stored 
> in the struct mempolicy and used later on mpol_rebind_policy().

So instead of an empty nodemask we would pass a nodemask where all bits 
are set? And they would stay set but the cpuset restrictions would 
effectively limit the interleaving to the allowed set?

rebind could ignore rebinds if all bits are set.


