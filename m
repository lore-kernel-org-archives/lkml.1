Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbZAHVn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbZAHVn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 16:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbZAHVnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 16:43:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36837 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757341AbZAHVnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 16:43:19 -0500
Date: Thu, 8 Jan 2009 22:39:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Message-ID: <20090108213901.GA26729@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com> <20090108143220.GA8717@redhat.com> <20090108193530.99D74FC3DD@magilla.sf.frob.com> <496663B6.3090709@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496663B6.3090709@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Casey Dahlin wrote:
>
> Roland McGrath wrote:
> >>> Since waitfd shouldn't consume the child termination notification
> >>> waitfd should be more widely usable than the wait*() interfaces.
> >
> > waitid can be used that way with WNOWAIT.
>
> Yes, but waitfd does not have this flag. The reason being waitfd just
> calls waitid internally, and there is no guarantee (afaik) that calling
> waitid with WNOWAIT multiple times in succession will yield different
> results each time. This breaks the streaming behavior of the descriptor.

Yes, do_wait(WNOWAIT) will return the same result on each call. Until
the next child dies, and this child is closer to the head of ->children
list.

But the reason is not that waitfd just calls waitid() internally. Let's
suppose we add another helper (or waitfd_read() can do this by hand) so
that read(waitfd_with_WNOWAIT_flag) correctly returns the info about all
childs. Now, what should the next read() do?


Btw. It is not that I am trying to argue against sys_waitfd(), but do
you have the "real life" example when it can be useful? Yes, poll().
But we have signalfd. SIGCHLD is not rt signal, but afaics this is not
the problem actually. Just curious.

Oleg.

