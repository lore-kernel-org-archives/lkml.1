Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbZAGVGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbZAGVGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbZAGVFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:05:48 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:60851 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138AbZAGVFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:05:47 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Jan 2009 13:05:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>, Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
In-Reply-To: <20090107205816.GC4597@elte.hu>
Message-ID: <alpine.DEB.1.10.0901071259210.17115@alien.or.mcafeemobile.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <20090107205816.GC4597@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009, Ingo Molnar wrote:

> 
> * Roland McGrath <roland@redhat.com> wrote:
> 
> > New syscall should have gone to linux-api, I think.
> > 
> > Do we really need another one for this?  How about using signalfd plus 
> > setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead 
> > of SIGCHLD?  It's slightly more magical for the userland process to know 
> > to do that (fork -> clone SIGRTMIN).  But compared to adding a syscall 
> > we don't really have to add, maybe better.
> 
> hm, i think it's cleaner conceptually than trying to wrap this into 
> signalfd. Since we already have:
> 
>   #define __NR_signalfd           321
>   #define __NR_timerfd_create     322
>   #define __NR_timerfd_settime    325
>   #define __NR_timerfd_gettime    326
>   #define __NR_signalfd4          327
> 
> is one more really such an issue?

And what did eventfd do to you? :)
I partially agree with Roland (and I stated this during Casey's first 
post), this can be achieved in a not too troublesome way already.
A new dedicated interface is easier for the challenged userspace coder, 
but I dunno if it's worth the new code (although it does have little 
footprint). Both ways are fine from my POV.



- Davide


