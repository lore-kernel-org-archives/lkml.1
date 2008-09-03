Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYICN6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYICN6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbYICN6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:58:03 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:42634 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYICN6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:58:00 -0400
From: Andrey Mirkin <major@openvz.org>
To: devel@openvz.org
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
Date: Wed, 3 Sep 2008 17:59:27 +0400
User-Agent: KMail/1.8.2
Cc: Cedric Le Goater <clg@fr.ibm.com>, Andrey Mirkin <major@openvz.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1220439476-16465-1-git-send-email-major@openvz.org> <48BE82F9.4020808@fr.ibm.com>
In-Reply-To: <48BE82F9.4020808@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031759.29132.major@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 16:28 Cedric Le Goater wrote:
> Andrey Mirkin wrote:
> > This patchset introduces kernel based checkpointing/restart as it is
> > implemented in OpenVZ project. This patchset has limited functionality
> > and are able to checkpoint/restart only single process. Recently Oren
> > Laaden sent another kernel based implementation of checkpoint/restart.
> > The main differences between this patchset and Oren's patchset are:
> >
> > * In this patchset checkpointing initiated not from the process
> > (right now we do not have a container, only namespaces), Oren's patchset
> > performs checkpointing from the process context.
> >
> > * Restart in this patchset is initiated from process, which restarts a
> > new process (in new namespaces) with saved state. Oren's patchset uses
> > the same process from which restart was initiated and restore saved state
> > over it.
> >
> > * Checkpoint/restart functionality in this patchset is implemented as a
> > kernel module
>
> why ? Do we really think that C/R implementations will be so different that
> we will need C/R ops to support all of them ? I imagine that there could be
> different models :
>
> 	1. brute force : dump it all and kill
> 	2. incremental
> 	3. live migration
> 	...
>
> But I see all of them really tied to the kernel internals.
>
> The first issues I see with this direction are some EXPORT_SYMBOL() that
> would be useless without a module.

Checkpoint/restart functionality is implemented as a kernel module to provide 
more flexibility during development process - you can easily unload module, 
fix what you need and load module again, you do not need to reboot you server 
in this case. We have discussed this question during Container's mini summit 
on OLS-2008 and we have found out that it will be convenient to have such an 
ability.

>
> > As checkpointing is initiated not from the process which state should be
> > saved we should freeze a process before saving its state. Right now
> > Container Freezer from Matt Helsley can be used for this.
>
> OK that's integrated and Daniel's tools :
>
> http://lxc.cvs.sourceforge.net/lxc/
>
> one more reason to work on integration :)

Yes, you're right :)

Regards,
Andrey

>
> > This patchset introduce only a concept how kernel based
> > checkpointing/restart can be implemented and are able to
> > checkpoint/restart only a single process with simple VMAs.
> >
> > I've tried to split my patchset in small patches to make review more
> > easier. _______________________________________________
> > Containers mailing list
> > Containers@lists.linux-foundation.org
> > https://lists.linux-foundation.org/mailman/listinfo/containers
>
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
>
> _______________________________________________
> Devel mailing list
> Devel@openvz.org
> https://openvz.org/mailman/listinfo/devel
