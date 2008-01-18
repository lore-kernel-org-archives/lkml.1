Return-Path: <linux-kernel-owner+w=401wt.eu-S932400AbYARVKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbYARVKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 16:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761375AbYARVKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 16:10:22 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43898 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762184AbYARVKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 16:10:21 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 18 Jan 2008 13:10:18 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pierre Habouzit <madcoder@debian.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: epoll and shared fd's
In-Reply-To: <20080118134318.GD9607@artemis.madism.org>
Message-ID: <Pine.LNX.4.64.0801181257240.24685@alien.or.mcafeemobile.com>
References: <20080118134318.GD9607@artemis.madism.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008, Pierre Habouzit wrote:

>   Hi,
> 
>   I just came across a strange behavior of epoll that seems to
> contradict the documentation. Here is what happens:
> 
> * I have two processes P1 and P2, P1 accept()s connections, and send the
>   resulting file descriptors to P2 through a unix socket.
> 
> * P2 registers the received socket in his epollfd.
> 
>   [time passes]
> 
> * P2 is done with the socket and closes it
> 
> * P2 gets events for the socket again !
> 
> 
>   Though the documentation says that if a process closes a file
> descriptor, it gets unregistered. And yes I'm sure that P2 doens't dup()
> the file descriptor. Though (because of a bug) it was still open in
> P1[0], hence the referenced socket still live at the kernel level.
> 
>   Of course the userland workaround is to force the EPOLL_CTL_DEL before
> the close, which I now do, but costs me a syscall where I wanted to
> spare one :|

For epoll, a close is when the kernel file* is released (that is, when all 
its instances are gone).
We could put a special handling in filp_close(), but I don't think is a 
good idea, and we're better live with the current behaviour.



- Davide


