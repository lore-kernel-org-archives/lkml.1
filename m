Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbXJ3XRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbXJ3XRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXJ3XRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:17:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34875 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbXJ3XRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:17:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=MIwc2D5qmnQIEdOmJ2gnttHb7L+gZ1EoX4ietYstcFVtarQ+qL1NgAQF1yS8mKsLO
	Fzs/oHOvS10J9LDfi4DJg==
Date: Tue, 30 Oct 2007 16:17:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, clameter@sgi.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071029114109.46285026.pj@sgi.com>
Message-ID: <alpine.DEB.0.9999.0710301615580.19750@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
 <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com> <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost>
 <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com> <1193670617.5035.38.camel@localhost> <20071029114109.46285026.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Paul Jackson wrote:

> But in any case, we (the kernel) are just providing the mechanisms.
> If they don't fit ones needs, don't use them ;).
> 

The kernel is providing the mechanism to interleave over a set of nodes or 
prefer a single node for allocations, but it also provides for remapping 
those to different nodes, without regard to locality or affinity to 
specific hardware, when the cpuset changes.  That's what Choice C is 
intended to replace: a node means a node so either you get an effected 
mempolicy over the nodemask you asked for, or MPOL_DEFAULT is used because 
you lack sufficient access.

		David
