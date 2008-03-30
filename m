Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbYC3QSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbYC3QSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 12:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYC3QSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 12:18:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:59905 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752971AbYC3QSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 12:18:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX185xA0ZPiw5fLxDWzISy53zh43hKSa33xweuJcX//
	JDvzHGMpkBcbLH
Subject: Re: Scalability requirements for sysv ipc (+namespaces broken with
	SEM_UNDO)
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Pavel Emelianov <xemul@openvz.org>
In-Reply-To: <47EF9FC2.3050901@colorfullife.com>
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
	 <47E3B924.3000304@colorfullife.com>
	 <20080321141339.GB9618@linux.vnet.ibm.com>
	 <47E3DD8C.4000904@colorfullife.com>
	 <1206164608.3659.11.camel@marge.simson.net>
	 <47E4DB06.3020003@colorfullife.com>
	 <1206186832.4545.1.camel@marge.simson.net>
	 <47E51637.8060102@colorfullife.com>  <47E55945.10109@colorfullife.com>
	 <1206460206.4414.21.camel@marge.simson.net>
	 <47EF9FC2.3050901@colorfullife.com>
Content-Type: text/plain
Date: Sun, 30 Mar 2008 19:18:08 +0200
Message-Id: <1206897488.4593.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-03-30 at 16:12 +0200, Manfred Spraul wrote:
> Mike Galbraith wrote:
> > On Sat, 2008-03-22 at 20:08 +0100, Manfred Spraul wrote:
> >
> >   
> >> just the normal performance of 2.6.25-rc3 is abyssimal, 55 to 60% slower 
> >> than 2.6.18.8:
> >>     
> >
> > After manually reverting 3e148c79938aa39035669c1cfa3ff60722134535,
> > 2.6.25.git scaled linearly
> We can't just revert that patch: with IDR, a global lock is mandatory :-(
> We must either revert the whole idea of using IDR or live with the 
> reduced scalability.

Yeah, I looked at the problem, but didn't know what the heck to do about
it, so just grabbed my axe to verify/quantify.

> Actually, there are further bugs: the undo structures are not 
> namespace-aware, thus semop with SEM_UNDO, unshare, create new array 
> with same id, but more semaphores, another semop with SEM_UNDO will 
> corrupt kernel memory :-(
> I'll try to clean up the bugs first, then I'll look at the scalability 
> again.

Great!

	-Mike


