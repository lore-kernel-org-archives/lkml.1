Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbXJBTww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbXJBTww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 15:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXJBTwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 15:52:45 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:41052 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbXJBTwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 15:52:44 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 2 Oct 2007 12:52:42 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Al Viro <viro@ftp.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: F_DUPFD_CLOEXEC implementation
In-Reply-To: <200710021028.13536.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0710021239580.17814@alien.or.mcafeemobile.com>
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com>
 <200710011949.03482.vda.linux@googlemail.com>
 <Pine.LNX.4.64.0710011158390.25942@alien.or.mcafeemobile.com>
 <200710021028.13536.vda.linux@googlemail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Denys Vlasenko wrote:

> I have following proposals:
> 
> * make recv(..., MSG_DONTWAIT) work on any fd
> 
> Sounds neat, but not trivial to implement in current kernel.

This is mildly ugly, if you ask me. Those are socket functions, and the 
flags parameter contain some pretty specific network meanings.



> * new fcntl command F_DUPFL: fcntl(fd, F_DUPFL, n):
>   Analogous to F_DUPFD, but gives you *unshared* copy of the fd.
>   Further seeks, fcntl(fd, F_SETFL, O_NONBLOCK), etc won't affect
>   any other process.

You'll need an ad-hoc copy function though, since your memcpy-based one is 
gonna explode even before memcpy returns ;) You'll have problems with 
ref-counting too. And that layer is not designed to cleanly support that 
operation.
Unfortunately the "clean" solution would involve changing a whole bunch of 
code, and I don't feel exactly sure it'd be worth it.



- Davide


