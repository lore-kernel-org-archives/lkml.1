Return-Path: <linux-kernel-owner+w=401wt.eu-S1765556AbXJZVkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765556AbXJZVkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbXJZVkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:40:04 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbXJZVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:40:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=imr6bgVuLmrlYI2KaL7qCjA6DMnOX4mQr6DXQZdgvhEw7q/YbjuIq0t2PMScquUlE
	E5KeKRfFoXdxkgBBoaBOQ==
Date: Fri, 26 Oct 2007 14:39:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Paul Jackson <pj@sgi.com>, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <1193434278.5032.106.camel@localhost>
Message-ID: <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>  <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>  <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>  <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
  <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>  <20071025185506.8c373aa8.pj@sgi.com>  <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>  <1193412644.5032.13.camel@localhost>  <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
  <20071026120037.7b95a136.pj@sgi.com>  <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>  <1193433239.5032.95.camel@localhost>  <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com> <1193434278.5032.106.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Lee Schermerhorn wrote:

> So, you pass the subset, you don't set the flag to indicate you want
> interleaving over all available.  You must be thinking of some other use
> for saving the subset mask that I'm not seeing here.  Maybe restoring to
> the exact nodes requested if they're taken away and then re-added to the
> cpuset?
> 

Paul's motivation for saving the passed nodemask to set_mempolicy() is so 
that the _intent_ of the application is never lost.  That's the biggest 
advantage that this method has and that I totally agree with.  So whenever 
the mems_allowed of a cpuset changes, the MPOL_INTERLEAVE nodemask of all 
attached tasks becomes their intent (pol->passed_nodemask) AND'd with the 
new mems_allowed.  That can be done on mpol_rebind_policy() and shouldn't 
be an extensive change.

So MPOL_INTERLEAVE, and possibly other, mempolicies will always try to 
accomodate the intent of the application but only as far as the task's 
cpuset restriction allows them.

		David
