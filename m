Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYICOUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYICOUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbYICOUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:20:01 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45459 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276AbYICOUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:20:00 -0400
Date: Wed, 3 Sep 2008 09:18:41 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Andrey Mirkin <major@openvz.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
Message-ID: <20080903141841.GA13425@us.ibm.com>
References: <1220439476-16465-1-git-send-email-major@openvz.org> <48BE82F9.4020808@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BE82F9.4020808@fr.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cedric Le Goater (clg@fr.ibm.com):
> Andrey Mirkin wrote:
> > This patchset introduces kernel based checkpointing/restart as it is
> > implemented in OpenVZ project. This patchset has limited functionality and
> > are able to checkpoint/restart only single process. Recently Oren Laaden
> > sent another kernel based implementation of checkpoint/restart. The main
> > differences between this patchset and Oren's patchset are:
> > 
> > * In this patchset checkpointing initiated not from the process
> > (right now we do not have a container, only namespaces), Oren's patchset
> > performs checkpointing from the process context.
> > 
> > * Restart in this patchset is initiated from process, which restarts a new
> > process (in new namespaces) with saved state. Oren's patchset uses the same
> > process from which restart was initiated and restore saved state over it.
> > 
> > * Checkpoint/restart functionality in this patchset is implemented as a kernel
> > module
> 
> why ? Do we really think that C/R implementations will be so different that
> we will need C/R ops to support all of them ? I imagine that there could be 
> different models :

At the mini-summit two reasons were brought up to make it a module:

	1. So sysadmins worried about security implications can
	completely unload the module

	2. So developers can unload and reload the module while
	testing.

> 	1. brute force : dump it all and kill
> 	2. incremental
> 	3. live migration 
> 	...

Actually I don't think we expected to use different implementations for
those.

> But I see all of them really tied to the kernel internals.
> 
> The first issues I see with this direction are some EXPORT_SYMBOL() that would 
> be useless without a module.
>
> > As checkpointing is initiated not from the process which state should be saved
> > we should freeze a process before saving its state. Right now Container Freezer
> > from Matt Helsley can be used for this.
> 
> OK that's integrated and Daniel's tools :
> 
> http://lxc.cvs.sourceforge.net/lxc/
> 
> one more reason to work on integration :)
> 
> C. 
> 
> 
> > This patchset introduce only a concept how kernel based checkpointing/restart
> > can be implemented and are able to checkpoint/restart only a single process
> > with simple VMAs. 
> > 
> > I've tried to split my patchset in small patches to make review more easier.
> > _______________________________________________
> > Containers mailing list
> > Containers@lists.linux-foundation.org
> > https://lists.linux-foundation.org/mailman/listinfo/containers
> > 
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
