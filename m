Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYICM2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYICM2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYICM2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:28:45 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:35332 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYICM2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:28:45 -0400
Message-ID: <48BE82F9.4020808@fr.ibm.com>
Date: Wed, 03 Sep 2008 14:28:41 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>
In-Reply-To: <1220439476-16465-1-git-send-email-major@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Mirkin wrote:
> This patchset introduces kernel based checkpointing/restart as it is
> implemented in OpenVZ project. This patchset has limited functionality and
> are able to checkpoint/restart only single process. Recently Oren Laaden
> sent another kernel based implementation of checkpoint/restart. The main
> differences between this patchset and Oren's patchset are:
> 
> * In this patchset checkpointing initiated not from the process
> (right now we do not have a container, only namespaces), Oren's patchset
> performs checkpointing from the process context.
> 
> * Restart in this patchset is initiated from process, which restarts a new
> process (in new namespaces) with saved state. Oren's patchset uses the same
> process from which restart was initiated and restore saved state over it.
> 
> * Checkpoint/restart functionality in this patchset is implemented as a kernel
> module

why ? Do we really think that C/R implementations will be so different that
we will need C/R ops to support all of them ? I imagine that there could be 
different models :

	1. brute force : dump it all and kill
	2. incremental
	3. live migration 
	...

But I see all of them really tied to the kernel internals.

The first issues I see with this direction are some EXPORT_SYMBOL() that would 
be useless without a module.

> As checkpointing is initiated not from the process which state should be saved
> we should freeze a process before saving its state. Right now Container Freezer
> from Matt Helsley can be used for this.

OK that's integrated and Daniel's tools :

http://lxc.cvs.sourceforge.net/lxc/

one more reason to work on integration :)

C. 


> This patchset introduce only a concept how kernel based checkpointing/restart
> can be implemented and are able to checkpoint/restart only a single process
> with simple VMAs. 
> 
> I've tried to split my patchset in small patches to make review more easier.
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 

