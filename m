Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbZEGQtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbZEGQtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbZEGQtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:49:39 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58107 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZEGQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:49:38 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 7 May 2009 09:44:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Avi Kivity <avi@redhat.com>
cc: Gregory Haskins <ghaskins@novell.com>, viro@ZenIV.linux.org.uk,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
In-Reply-To: <4A030287.8010104@redhat.com>
Message-ID: <alpine.DEB.1.10.0905070944410.31280@makko.or.mcafeemobile.com>
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com>
 <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com> <4A02AE65.3000800@redhat.com> <alpine.DEB.1.10.0905070744490.30708@makko.or.mcafeemobile.com> <4A030287.8010104@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009, Avi Kivity wrote:

> Davide Libenzi wrote:
> >   
> > > What's your take on adding irq context safe callbacks to irqfd?
> > > 
> > > To give some background here, we would like to use eventfd as a generic
> > > connector between components, so the components do not know about each
> > > other.
> > > So far eventfd successfully abstracts among components in the same
> > > process, in
> > > different processes, and in the kernel.
> > > 
> > > eventfd_signal() can be safely called from irq context, and will wake up a
> > > waiting task.  But in some cases, if the consumer is in the kernel, it may
> > > be
> > > able to consume the event from irq context, saving a context switch.
> > > 
> > > So, will you consider patches adding this capability to eventfd?
> > >     
> > 
> > Maybe I got lost in the thread, but inside the kernel we have callback-based
> > wakeup since long time. This is what epoll uses, when hooking into the file*
> > f_op->poll() subsystem.
> > Did you mean something else?
> >   
> 
> Do you mean wait_queue_t::func?

Yes, it is since long time ago that a wakeup in Linux can lead either to a 
real wakeup (in scheduler terms), or to a simple function call.
Isn't that enough?


- Davide


