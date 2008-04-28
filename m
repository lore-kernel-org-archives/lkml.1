Return-Path: <linux-kernel-owner+w=401wt.eu-S1765531AbYD1GGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765531AbYD1GGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbYD1GGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:06:05 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50251 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbYD1GGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:06:04 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 27 Apr 2008 23:06:03 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] eventfd, signalfd, timerfd, epoll_create w/flags
In-Reply-To: <481563E4.5090408@redhat.com>
Message-ID: <Pine.LNX.4.64.0804272301270.18184@alien.or.mcafeemobile.com>
References: <200804280315.m3S3FKsw028335@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0804272200090.18184@alien.or.mcafeemobile.com>
 <481563E4.5090408@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Davide Libenzi wrote:
> > unsigned int oflags_remap(const struct oflags_rmap *m, int n,
> > 			  int f, int *rf)
> > {
> > 	int i;
> > 	for (i = 0, *rf = 0; i < n; i++, m++)
> > 		if (f & m->f) {
> > 			*rf |= m->of;
> > 			f &= ~m->f;
> > 		}
> > 	return f ? -EINVAL: 0;
> > }
> 
> This will be more expensive in terms of code and runtime.  Plus: who
> knows whether there will really be other flags which can be used like
> this?  I think it's overkill to do this.  If at some point there are
> more flags which are handled the same way one could do something like
> this but I don't think it's necessary now.

There are already, not one, not two, not three, but four call sites where 
an aweful cut&paste is used to basically do the same thing. And probably 
there's another one you likely did for the sockets.




- Davide


