Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbZFWTzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbZFWTzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbZFWTzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:55:11 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:43380 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbZFWTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:55:10 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 12:49:02 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, avi@redhat.com,
       kvm@vger.kernel.org, ghaskins@novell.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
In-Reply-To: <20090623124807.eb9042a5.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906231244090.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com> <20090623124807.eb9042a5.akpm@linux-foundation.org>
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
> > The following patch changes the eventfd interface to de-couple the eventfd 
> > memory context, from the file pointer instance.
> > Without such change, there is no clean way to racely free handle the 
> > POLLHUP event sent when the last instance of the file* goes away.
> > Also, now the internal eventfd APIs are using the eventfd context instead 
> > of the file*.
> > Another cleanup this patch does, is making AIO select EVENTFD, instead of 
> > adding a bunch of empty function stubs inside eventfd.h in order to 
> > handle the (AIO && !EVENTFD) case.
> > 
> 
> If we really want to squeeze this into 2.6.31 then it would be helpful
> to have justification in the changelog, please.  I see that some KVM
> feature needs it, but what and why and why now, etc?

The patch in -next added the ability to have waiters to be notified when 
the last instance of the file* is dropped (that is, on ->release).
But it is not possible for waiters to handle the POLLHUP event in a 
racy-free way, unless the eventfd memory context is de-coupled from the 
file*.
The next patches from gregory will use eventfd (and the POLLHUP handling) 
to implement the IRQfd code inside KVM.


> What's going on here?

The POLLHUP patch in -next is not sufficent. I based the patch over 
mainline, but if you guys want I can rebase it over -next.



- Davide


