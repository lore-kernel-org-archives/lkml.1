Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZFWVGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZFWVGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbZFWVFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:05:13 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54178 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbZFWVFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:05:11 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 13:59:07 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, avi@redhat.com,
       kvm@vger.kernel.org, ghaskins@novell.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
In-Reply-To: <20090623131239.711d9f83.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906231355130.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com> <20090623131239.711d9f83.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Andrew Morton wrote:

> On Tue, 23 Jun 2009 12:25:36 -0700 (PDT)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > Another cleanup this patch does, is making AIO select EVENTFD, instead of 
> > adding a bunch of empty function stubs inside eventfd.h in order to 
> > handle the (AIO && !EVENTFD) case.
> 
> Given that we're trying to squeak this patch into 2.6.31, it's quite
> unfortunate to include unrelated changes.  Especially ones which
> involve the always-problematic "select".  Although this one looks less
> than usually deadly due to the simple dependencies of AIO and eventfd.
> 
> However...
> 
> Is this a good way of fixing the (AIO && !EVENTFD) case?  Surely if the
> developer selected this combination, he doesn't want to carry the
> overhead of including eventfd.  IOW, if AIO can work acceptably without
> eventfd being compiled into the kernel then adding the stubs is a
> superior solution.

IMO when someone says "AIO included in the kernel", should get the whole 
AIO functionality and not part of it.
People already started using KAIO+eventfd, and a (AIO && !EVENTFD) config 
will make their code fail.


- Davide


