Return-Path: <linux-kernel-owner+w=401wt.eu-S1760010AbYEFCS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760010AbYEFCS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbYEFCSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:18:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbYEFCSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:18:14 -0400
Date: Mon, 5 May 2008 19:17:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, mtk.manpages@gmail.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/18] flag parameters: socket and socketpair
Message-Id: <20080505191725.89faed88.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805051910050.20837@alien.or.mcafeemobile.com>
References: <200805050342.m453gktl029817@devserv.devel.redhat.com>
	<20080505185850.789d870a.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805051910050.20837@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 19:13:14 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Mon, 5 May 2008, Andrew Morton wrote:
> 
> > On Sun, 4 May 2008 23:42:46 -0400 Ulrich Drepper <drepper@redhat.com> wrote:
> > 
> > > +static const struct flags_rmap sock_file_flags_remap[] = {
> > > +	{ SOCK_CLOEXEC, O_CLOEXEC },
> > > +};
> > > +
> > >  asmlinkage long sys_socket(int family, int type, int protocol)
> > >  {
> > >  	int retval;
> > >  	struct socket *sock;
> > > +	int fflags;
> > > +
> > > +	type = flags_remap(sock_file_flags_remap,
> > > +			   ARRAY_SIZE(sock_file_flags_remap),
> > > +			   type, &fflags);
> > 
> > oh, so that's what it does.
> > 
> > afaict we only ever remap one or two flags.  Would it not be more efficient
> > to do that inline?  Something along the lines of:
> > 
> > 	type = flag_remap(type, &fflags, SOCK_whatever, O_whatever);
> > 	type = flag_remap(type, &fflags, SOCK_whatever2, O_whatever2);
> > 
> > ?
> 
> I think it is better to keep it able to remap more than one flag, with a 
> single call, that is table driven.
> 

The table-driven approach is slower for one and probably two bits and it is
somewhat less readable.  What do we gain in return for this?
