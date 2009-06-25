Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbZFYQj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbZFYQj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZFYQjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:39:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:56128 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZFYQjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:39:17 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 25 Jun 2009 09:34:31 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Gregory Haskins <ghaskins@novell.com>, mst@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com, paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] eventfd: add internal reference counting to fix
 notifier race conditions
In-Reply-To: <200906252112.24730.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0906250922530.9517@makko.or.mcafeemobile.com>
References: <20090619183534.31118.30934.stgit@dev.haskins.net> <200906241255.54709.rusty@rustcorp.com.au> <alpine.DEB.1.10.0906241154350.30928@makko.or.mcafeemobile.com> <200906252112.24730.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Rusty Russell wrote:

> On Thu, 25 Jun 2009 08:15:11 am Davide Libenzi wrote:
> >
> > Some components would like to know if userspace dropped the fd, and take
> > proper action accordingly (release resources, drop module instances,
> > etc...).
> 
> Like to know?  Possibly.  Need to know?  Not anything I've seen so far.
> 
> If userspace creates the fd, component grab a ref and if userspace wants that 
> fd completely freed must close the fd *and* tell component.  Simple, race free 
> and explicit.  All wins.
> 
> As this discussion shows, doing some kind of implies non-reference is hard, 
> complex and racy.

Easier, we agree. Not doing anything is always easier, provided the 
userspace interface allows for it.
Cleaner, I'm not sure. Again, it depends from the userspace interface, but 
usually when you close(2) something, you expect the kernel to react 
accordingly, and not on relying on userspace issuing extra calls in order 
to proper cleanup the kernel context.
This is even more true when the eventfd is the sole handle to the visisble 
userspace interface.
In such cases, not taking proper action on close(2) and requiring extra 
calls, would lead to designing interface with the close-no-really-i-mean-it
patterns.



- Davide


