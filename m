Return-Path: <linux-kernel-owner+w=401wt.eu-S1760612AbZDWWHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760612AbZDWWHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZDWWH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:07:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50316 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbZDWWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:07:27 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 23 Apr 2009 15:03:47 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH 2/3] eventfd: add a notifier mechanism
In-Reply-To: <49F09B78.7000403@novell.com>
Message-ID: <alpine.DEB.1.10.0904231500570.18603@makko.or.mcafeemobile.com>
References: <20090423150910.14094.73708.stgit@dev.haskins.net> <20090423151436.14094.35875.stgit@dev.haskins.net> <alpine.DEB.1.10.0904230922180.18603@makko.or.mcafeemobile.com> <49F09B78.7000403@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Thu, 23 Apr 2009, Gregory Haskins wrote:
> >
> >   
> >> This allows synchronous notifications to register with the eventfd
> >> infrastructure.  Unlike traditional vfs based eventfd readers, notifiees
> >> do not implictly clear the counter on reception.  However, the clearing
> >> is primarily important to allowing threads to block waiting for events
> >> anyway, so its an acceptable trade-off since blocking doesn't apply to
> >> notifiers.
> >>     
> >
> > Do you really need to add a notifier? Eventfd already has a wait queue, 
> > and we support callback-based wakeups, so is there any reason we shouldn't 
> > use those and rely on the already existing wakeups?
> >   
> Well, IIUC the issue is that a wait queue implies that you are in fact
> waiting...which we may not. :)
> 
> The target in this particular application with kvm-irqfd is a vcpu
> context, which *may* be sleeping in something like a HLT, but it also
> could be in a number of other states such as non-root (guest) mode, it
> could be running in the kernel, it could be up in userspace, etc.
> 
> That said: I am not married to the concept that this has to be a
> notifier callback, but I do want to be able to meet the target
> application.  So if there is some way to do that within the existing
> wait-queue contstruct, I am open to suggestions.

Take a look at init_waitqueue_func_entry(), in particula at that "func" 
parameter. Then look at how __wake_up_common() does its thing.
You don't need to be "waiting" for our wakeup system to work. Callbacks 
works just fine, otherwise things like epoll could not work at all.



- Davide


