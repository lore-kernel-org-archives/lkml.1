Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbYB2SxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbYB2SxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760813AbYB2Sw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:52:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35542 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758118AbYB2Sw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:52:57 -0500
Date: Fri, 29 Feb 2008 18:40:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, linux-kernel <linux-kernel@vger.kernel.org>,
       drepper@redhat.com, mtk.manpages@gmail.com
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
Message-ID: <20080229184044.6b5347eb@core>
In-Reply-To: <1204307756.6243.121.camel@lappy>
References: <1204119455.6242.403.camel@lappy>
	<alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
	<c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
	<1204305244.6243.111.camel@lappy>
	<alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org>
	<1204307756.6243.121.camel@lappy>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 18:55:56 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Fri, 2008-02-29 at 09:35 -0800, Linus Torvalds wrote:
> > 
> > On Fri, 29 Feb 2008, Peter Zijlstra wrote:
> > > 
> > > You fail to mention that <23 will still fault the first time it tries to
> > > grow the stack when you set rlimit_stack to 128k and actually supply
> > > 128k of env+arg.
> > 
> > So? That's what rlimit_stack has always meant (and not just on Linux 
> > either, afaik). That's not a bug, it's a feature. If the system has a 
> > limited stack, it has a limited stack. That's what RLIMIT_STACK means.
> 
> Well, I agree with that point. It just that apparently POSIX does not.
> According to Michael POSIX does not consider the arg+env array part of
> the stack proper.

As far as I can see POSIX and SuS do not care. In all the ABIs some of
your stack is already used by stuff. Posix doesn't seem to consider it
either way. By some undefined magic main() gets argc, argv, envp. Quite
frankly it could read them from a pipe before main is called.

Alan
