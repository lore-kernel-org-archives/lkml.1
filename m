Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYEFCN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYEFCN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754142AbYEFCNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:13:17 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51539 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYEFCNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:13:16 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 May 2008 19:13:14 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, mtk.manpages@gmail.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
In-Reply-To: <20080505185850.789d870a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805051910050.20837@alien.or.mcafeemobile.com>
References: <200805050342.m453gktl029817@devserv.devel.redhat.com>
 <20080505185850.789d870a.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Andrew Morton wrote:

> On Sun, 4 May 2008 23:42:46 -0400 Ulrich Drepper <drepper@redhat.com> wrote:
> 
> > +static const struct flags_rmap sock_file_flags_remap[] = {
> > +	{ SOCK_CLOEXEC, O_CLOEXEC },
> > +};
> > +
> >  asmlinkage long sys_socket(int family, int type, int protocol)
> >  {
> >  	int retval;
> >  	struct socket *sock;
> > +	int fflags;
> > +
> > +	type = flags_remap(sock_file_flags_remap,
> > +			   ARRAY_SIZE(sock_file_flags_remap),
> > +			   type, &fflags);
> 
> oh, so that's what it does.
> 
> afaict we only ever remap one or two flags.  Would it not be more efficient
> to do that inline?  Something along the lines of:
> 
> 	type = flag_remap(type, &fflags, SOCK_whatever, O_whatever);
> 	type = flag_remap(type, &fflags, SOCK_whatever2, O_whatever2);
> 
> ?

I think it is better to keep it able to remap more than one flag, with a 
single call, that is table driven.



- Davide


