Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZAJXOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZAJXOU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 18:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZAJXOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 18:14:05 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47961 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZAJXOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 18:14:03 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Jan 2009 15:14:01 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Scott James Remnant <scott@canonical.com>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
In-Reply-To: <20090110222434.GA24414@redhat.com>
Message-ID: <alpine.DEB.1.10.0901101511590.22208@alien.or.mcafeemobile.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107205322.5F8C7FC3E0@magilla.sf.frob.com> <1231598714.11642.53.camel@quest> <20090110155720.GA10954@redhat.com> <1231607252.11642.103.camel@quest>
 <20090110181340.GA14978@redhat.com> <1231618407.11642.196.camel@quest> <20090110222434.GA24414@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Oleg Nesterov wrote:

> > Thus:
> >
> >  - child process #1 dies
> >  - main loop woken up by SIGCHLD
> >  - pending status of signal cleared
> >  - enter wait loop
> >  - child process #2 dies
> >  - SIGCHLD pending again
> >  - waitpid() called first time, child process #1 reaped
> >  - waitpid() called second time, child process #2 reaped
> >    (SIGCHLD still pending)
> >  - waitpid() called third time, no child processes remain
> >  - exit wait loop
> >  - back to top of main loop, immediately woken up by pending SIGCHLD
> >  - pending status of signal cleared
> >  - enter wait loop
> >  - waitpid() called first time, but no child processes remain
> >    (we reaped it last time round)
> >  - exit wait loop
> >  - back to top of main loop, sleep
> 
> Scott, I don't really understand why are you trying to explain this
> all to me. I do understand this. At least I hope ;)

Indeed :)
Scott, you're teaching Linux signals to the guy that is likely the 
de-facto mantainer of the subsystem. See the irony?



- Davide


