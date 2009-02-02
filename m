Return-Path: <linux-kernel-owner+w=401wt.eu-S1757692AbZBBUSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbZBBUSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZBBUS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:18:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54390 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZBBUS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:18:28 -0500
Message-ID: <498754EF.8090604@redhat.com>
Date: Mon, 02 Feb 2009 12:17:51 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Kaz Kylheku <kkylheku@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com> <20090201174159.4a52e15c.akpm@linux-foundation.org> <20090202064509.GA20237@redhat.com> <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com> <20090202165606.GA13346@redhat.com>
In-Reply-To: <20090202165606.GA13346@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Oleg Nesterov wrote:
> I am worried this patch can confuse the user-space. Because, when
> the main thread does sys_exit(), the user-space has all rights
> to assume it exits ;) But with this patch the main thread will
> continue to handle the signals until the while group exits, I'm
> afraid libpthread.so won't be happy.

I haven't looked at the patch nor tried it.

If the patch changes the behavior that the main thread, after calling
sys_exit, still react to signals sent to this thread or to the process
as a whole, then the patch is wrong.  The userlevel context of the
thread is not usable anymore.  It will have run all kinds of
destructors.  The current behavior is AFAIK that the main thread won't
react to any signal anymore.  That is absolutely required.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmHVO8ACgkQ2ijCOnn/RHTJvwCgodxkT+mg0tmrnlhf/IP8hUQc
RYIAn0YC7pTjPHHZa7kmvYSyu/Zw5IIT
=ehdX
-----END PGP SIGNATURE-----
