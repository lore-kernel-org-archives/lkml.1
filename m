Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbXGARBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbXGARBi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 13:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXGARBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 13:01:32 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3473 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbXGARBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 13:01:31 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 1 Jul 2007 10:01:23 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Heikki Orsila <shdl@zakalwe.fi>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mtk-manpages@gmx.net
Subject: Re: Man page correction: epoll (7)
In-Reply-To: <20070701122225.GB3400@zakalwe.fi>
Message-ID: <Pine.LNX.4.64.0707010953250.7547@alien.or.mcafeemobile.com>
References: <20070701122225.GB3400@zakalwe.fi>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2007, Heikki Orsila wrote:

> So, the Q9 should be changed:
> 
> Q9	Do I need to continuously read/write an  fd  until  EAGAIN when
> 	using the EPOLLET flag ( Edge Triggered behaviour ) ?
> 
> A9	As a general rule, yes. However, there are exceptions.
> 	With some types of fds it is enough to wait until
> 	read returns less bytes than was requested by the read call.
> 
> Are there any fd types where such behavior is guaranteed by the Linux 
> kernel (for the future)? I.e. one can assume that edge-triggered fds 
> will behave properly if
> 
> 	x = read(fd, data, count) and x < count ?
> 
> Regular files? Sockets? What?

Basically, any "streaming" file. That is, any file that tends to fill up 
the buffer you supply to the call in full (till they have data in their 
buffers, that is). Packet/token oriented files would be the ones you 
cannot apply the rule to, since data is returned in multiple of tokens.


- Davide


