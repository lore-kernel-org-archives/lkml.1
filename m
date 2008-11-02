Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYKBSZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYKBSZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 13:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYKBSZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 13:25:36 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:60623 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbYKBSZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 13:25:35 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 2 Nov 2008 10:25:27 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Olaf van der Spek <olafvdspek@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: epoll behaviour after running out of descriptors
In-Reply-To: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com>
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008, Olaf van der Spek wrote:

> Hi,
> 
> I noticed some strange behaviour of epoll after running out of descriptors.
> I've registered a listen socket to epoll with edge triggering. On the
> client-side I use an app that simply keeps opening connections.
> When accept returns EMFILE, I call epoll_wait and accept and it
> returns with another EMFILE.
> This happens 10 times or so, after that epoll_wait no longer returns
> with the listen socket ready.
> I then close all file descriptors, but epoll_wait will still not return.
> So my question is, why does it 'only' happen 10 times and what is the
> expected behaviour?
> And how should an app handle this?
> 
> The example in the epoll man page doesn't seem to handle this.
> 
> An idea I had was for epoll_wait to only return with accept / EMFILE
> once. Then after a descriptor becomes available, epoll_wait would
> return again.
> 
> See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=502901
> 
> Hi,
> 
> I've written a web app that should be able to handle a lot of new
> connections per second (1000+). On multiple servers I've hit a bug.
> After running out of descriptors, then closing descriptors, epoll_wait
> doesn't return anymore for the listen socket.
> I've attached code to reproduce the issue. And an strace log. Even
> before closing the descriptors you see epoll_wait already stops returning.

A bug? For starters, epoll_wait does NOT create new files, so no EMFILE 
can come out from there.
You are saturating the port space, and your whole code logic is rather (at 
least) buggy. Try a `netstat -n -t | grep TIME_WAIT | wc -l`



- Davide


