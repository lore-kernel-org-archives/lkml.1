Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbZDXQR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbZDXQR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 12:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbZDXQRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 12:17:10 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:56554 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbZDXQRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 12:17:06 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 24 Apr 2009 09:13:23 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH 2/3] eventfd: add a notifier mechanism
In-Reply-To: <49F13C0B.6040408@novell.com>
Message-ID: <alpine.DEB.1.10.0904240911280.13272@makko.or.mcafeemobile.com>
References: <20090423150910.14094.73708.stgit@dev.haskins.net> <20090423151436.14094.35875.stgit@dev.haskins.net> <alpine.DEB.1.10.0904230922180.18603@makko.or.mcafeemobile.com> <49F09B78.7000403@novell.com> <alpine.DEB.1.10.0904231500570.18603@makko.or.mcafeemobile.com>
 <49F0E7B4.90702@novell.com> <alpine.DEB.1.10.0904231942000.18603@makko.or.mcafeemobile.com> <49F13C0B.6040408@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Gregory Haskins wrote:

> Davide Libenzi wrote:
> > On Thu, 23 Apr 2009, Gregory Haskins wrote:
> >
> >   
> >>> Take a look at init_waitqueue_func_entry(), in particula at that "func" 
> >>> parameter. Then look at how __wake_up_common() does its thing.
> >>> You don't need to be "waiting" for our wakeup system to work. Callbacks 
> >>> works just fine, otherwise things like epoll could not work at all.
> >>>   
> >>>       
> >> Yeah, I was looking at that this afternoon after you mentioned it.  That
> >> makes sense.
> >>
> >> As of right now the wqh is embedded in the eventfd, accessible only by
> >> the .read() vtable entry.  In order to do this as you suggest, I imagine
> >> I need to slightly modify the eventfd interface to allow waiters other
> >> than the embedded readers to join the wait-queue.  How would you like to
> >> see that interface look?
> >>     
> >
> > Actually, you need no changes in eventfd, since you can use its poll() 
> > directly, by dropping a callback entry.
> > Take a look at how epoll does it in ep_insert()...
> >   
> Ah!  I just tried your suggestion and it was simple and it works.  That
> is brilliant.
> 
> I will post a follow-up v2 that drops patch 2/3.  Thanks, Davide.

I assume you're in control of the file/fd lifetime, so that the file* 
cannot vanish while you've your wait_queue dropped inside its 
wait_queue_head, isn't it?


- Davide


