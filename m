Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYJ0BS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYJ0BS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 21:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYJ0BSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 21:18:18 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:43045 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYJ0BSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 21:18:18 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 26 Oct 2008 18:18:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Paul P <ppak_98@yahoo.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: unexpected extra pollout events from epoll
In-Reply-To: <107660.83879.qm@web56306.mail.re3.yahoo.com>
Message-ID: <Pine.LNX.4.64.0810261812510.19212@alien.or.mcafeemobile.com>
References: <107660.83879.qm@web56306.mail.re3.yahoo.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008, Paul P wrote:

> > You do that by writing data until it's finished, or you
> > get EAGAIN. If you
> > get EAGAIN, you listen for EPOLLOUT.
> > Reading is same, but you'd wait for EPOLLIN.
> 
> I've got a few questions about this approach.  The most logical 
> way to do this seems to be:
> 
> 1) Leave the epoll_wait with the EPOLLIN|EPOLLOUT event flags and
>  use epoll_ctl to switch the interest mask for each fd between EPOLLIN 
> and EPOLLOUT on a per fd basis.

Which version of epoll do you have? The epoll_wait() function does not 
accept an event mask (like you write above, EPOLLIN|EPOLLOUT). It never 
had.
But yes, you'd switch interest with epoll_ctl().



> 2) When I'm ready to write, I do a write and if it does not fully 
> write and I get the EAGAIN flag, I switch the fd with epoll_ctl(fd,MOD,EPOLLOUT). 

As optimization, if the EPOLLOUT bit is already set, you don't need to 
keep calling epoll_ctl(fd,MOD,EPOLLOUT).



> However, I get strange behavior when I tried adding fd's with only the 
> EPOLLIN interest mask. If I use epoll_wait with both the EPOLLIN and 
> EPOLLOUT interest mask, but add fd's with only the EPOLLIN interest mask,
> I still seem to get EPOLLOUT events on the fd.

Again, how the heck do you "use epoll_wait with both the EPOLLIN and 
EPOLLOUT"?!? There is not such a thing.




> So, I'm a little confused.

>From the wording above, that doesn't seem like a wrong guess.



- Davide


