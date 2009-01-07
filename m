Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbZAGRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbZAGRxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZAGRxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:53:06 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:52864 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbZAGRxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:53:05 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 7 Jan 2009 09:52:46 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
In-Reply-To: <20090107171922.GA18000@redhat.com>
Message-ID: <alpine.DEB.1.10.0901070949050.16651@alien.or.mcafeemobile.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com> <20090107123457.GB16268@elte.hu> <20090107171922.GA18000@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2009, Oleg Nesterov wrote:

> minor nit...
> 
> Please note that unlike other sys_...fd() syscalls, sys_waitfd()
> doesn't allow to pass O_CLOEXEC. Looks like we need a separate
> "flags" argument...

I said this even during the first post. Not a minor nit unless we want to 
have a sys_waitfd2 soon after.


> Also, ioctl(FIONBIO) or fcntl(O_NONBLOCK) have no effect on
> waitfd, not very good.

Ack.

 
> I'd suggest to remove WNOHANG from waitfd_ctx->ops and treat
> (->f_flags & O_NONBLOCK) as WNOHANG.

Ack.


> (can't resist, ->ops is not the best name ;)

Ack. "flags" looks a pretty nice shot at it.



- Davide


