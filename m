Return-Path: <linux-kernel-owner+w=401wt.eu-S1758582AbXJ3W5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbXJ3W5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 18:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845AbXJ3W5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 18:57:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28774 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbXJ3W5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 18:57:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=SYvqqzjzguLUBzgdTkOPrtKNwKtsZ/QPJA0B41GD8frWdu8wFfMb2BS8fecD3dYFO
	IrSI9ZIdlZCjs5qHflH6w==
Date: Tue, 30 Oct 2007 15:57:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Paul Jackson <pj@sgi.com>, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <1193670617.5035.38.camel@localhost>
Message-ID: <alpine.DEB.0.9999.0710301554450.15640@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>  <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>  <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>  <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
  <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>  <20071025185506.8c373aa8.pj@sgi.com>  <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>  <1193412644.5032.13.camel@localhost>  <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
  <20071026120037.7b95a136.pj@sgi.com>  <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>  <1193433239.5032.95.camel@localhost>  <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>  <1193434278.5032.106.camel@localhost> 
 <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com> <1193670617.5035.38.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Lee Schermerhorn wrote:

> And even when the intent is to preserve the cpuset relative positions of
> the nodes in the nodemask, this really only makes sense if the original
> and modified cpusets have the same physical topology w/rt multi-level
> NUMA interconnects.  This is something that has bothered me about
> dynamic cpusets and current policy remapping.  We don't do a good job of
> explaining the implications of changing cpuset topology on applications,
> nor do we handle it very well in the code.  Paul addresses one of my
> concerns in a later message in this thread, so I'll comment there.
> 

I agree with your assessment of our current policy remapping with respect 
to the passed nodemask, I think it's troublesome.  Whether we can change 
that now is another question, but the remap certainly doesn't help respect 
the intent of the application and the mempolicies they have set up when 
influenced by an outside entity such as cpusets.

See my new Choice C alternative.

		David
