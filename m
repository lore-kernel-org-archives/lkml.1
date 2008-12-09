Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYLITFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYLITFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 14:05:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYLITE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 14:04:58 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47358 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753579AbYLITE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 14:04:58 -0500
Date: Tue, 9 Dec 2008 19:04:03 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Scott James Remnant <scott@netsplit.com>
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
Message-ID: <20081209190403.2731dfd0@lxorguk.ukuu.org.uk>
In-Reply-To: <493EBD23.3020800@redhat.com>
References: <493EA441.1070706@redhat.com>
	<20081209170543.59b4fb73@lxorguk.ukuu.org.uk>
	<493EBD23.3020800@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This propogates the fundamental braindamage of waitpid - the fact the
> > notification only works on child process trees.
> >
> > Here is a more elegant suggestion - use epoll, inotify and friends  fully
> > on /proc process nodes.

> Last I checked inotify was not supported in /proc, or at least most of 
> it. What kind of work load is it to change that?

I don't know but I think it would be the better approach to find it. That
also separates notification of state to parents from the general problem
of wanting to know when a service has died, which seems to be an ever
more common point of interest on the desktop in particular.

File content change notification for /proc is hard because the contents
don't exist in the normal way and get updated but can be done if there is
a wait queue for the job. Actual changes to structure (new directories
etc) is in part a similar problem but there are clear points already in
existence when the proc nodes are created/destroyed and thus notification
can occur.
