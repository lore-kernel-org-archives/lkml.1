Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYHSPXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYHSPXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 11:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYHSPXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 11:23:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYHSPXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 11:23:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <a4423d670808190536m7896c849xaa47ab608e954cf9@mail.gmail.com>
References: <a4423d670808190536m7896c849xaa47ab608e954cf9@mail.gmail.com>
To: "Alexander Beregalov" <a.beregalov@gmail.com>
Cc: dhowells@redhat.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 19: CRED: BUG: bad unlock balance detected!
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Tue, 19 Aug 2008 16:23:18 +0100
Message-ID: <24643.1219159398@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexander Beregalov <a.beregalov@gmail.com> wrote:

> [   25.742287] [ BUG: bad unlock balance detected! ]
> [   25.750284] -------------------------------------
> [   25.758404] rc/404 is trying to release lock (&p->cred_exec_mutex) at:
> [   25.766716] [<00000000006aff78>] mutex_unlock+0x10/0x20
> [   25.775078] but there are no more locks to release!

I forgot to lock cred_exec_mutex in compat_do_execve().  I've posted a patch
which should fix this:

Subject: [PATCH] CRED: Take cred_exec_mutex in compat_do_execve() and fix
	error handling in do_execve()

David
