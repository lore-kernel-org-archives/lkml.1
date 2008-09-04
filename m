Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbYIDIO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbYIDIO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYIDIOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:14:43 -0400
Received: from serrano.cc.columbia.edu ([128.59.29.6]:60175 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbYIDIOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:14:42 -0400
Message-ID: <48BF98EB.5080602@cs.columbia.edu>
Date: Thu, 04 Sep 2008 04:14:35 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrey Mirkin <major@openvz.org>
CC: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>
In-Reply-To: <1220439476-16465-1-git-send-email-major@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrey Mirkin wrote:
> This patchset introduces kernel based checkpointing/restart as it is
> implemented in OpenVZ project. This patchset has limited functionality and
> are able to checkpoint/restart only single process. Recently Oren Laaden
> sent another kernel based implementation of checkpoint/restart. The main
> differences between this patchset and Oren's patchset are:

Thanks Andrey. I'll take a close look at it by the weekend. Just a couple
of comments after a very brief look at the code:

> 
> * In this patchset checkpointing initiated not from the process
> (right now we do not have a container, only namespaces), Oren's patchset
> performs checkpointing from the process context.

Actually, my patch is written to checkpoint from outside the context of the
target task;  for simplicity only, it is applied to the current process.

> 
> * Restart in this patchset is initiated from process, which restarts a new
> process (in new namespaces) with saved state. Oren's patchset uses the same
> process from which restart was initiated and restore saved state over it.

Here, too, handling of namespaces was left out in order to provide a simple
proof of concept. In fact, spawning a new process and entering a new namespace
can be easily done in user-space.

Oren.

> 
> * Checkpoint/restart functionality in this patchset is implemented as a kernel
> module
> 
> 
> As checkpointing is initiated not from the process which state should be saved
> we should freeze a process before saving its state. Right now Container Freezer
> from Matt Helsley can be used for this.
> 
> This patchset introduce only a concept how kernel based checkpointing/restart
> can be implemented and are able to checkpoint/restart only a single process
> with simple VMAs. 
> 
> I've tried to split my patchset in small patches to make review more easier.
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
