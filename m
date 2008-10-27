Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbYJ0A7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbYJ0A7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 20:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbYJ0A6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 20:58:51 -0400
Received: from web56306.mail.re3.yahoo.com ([216.252.110.230]:36538 "HELO
	web56306.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751483AbYJ0A6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 20:58:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=xtB6tG6IJI0tYjIpNnRcwnEFOJZGk9pjvVuOHTOEjLGkpDusER1tIVyKOnvbz5eKH8xMX0SIydXfJ4wYJbm8J+DEOKaSQhnUuUCcpWI5AYg73DGhMCVvMKQ2gvBDtNv6q31DlOmB67SqHOwW4wlpR+IIYCaRFixIdoZebZOVe68=;
X-YMail-OSG: SqjSyTMVM1n31EIh_Lj7zXXm84oBglpRLcODI.wfGc640xuv7h2lD4Wba_cZufCo9ODN_ozHe4zrALRmRGo87SW3tvW9THHWuyS_N5DTYjfPt6tu.9L0.8AM2h8nb18sJpE1fWdCZIjF7Be9h1ibi2LpFrwDrU1rV0Q4J_w-
X-Mailer: YahooMailWebService/0.7.247.3
Date: Sun, 26 Oct 2008 17:58:49 -0700 (PDT)
From: Paul P <ppak_98@yahoo.com>
Reply-To: ppak_98@yahoo.com
Subject: Re: unexpected extra pollout events from epoll
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <107660.83879.qm@web56306.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You do that by writing data until it's finished, or you
> get EAGAIN. If you
> get EAGAIN, you listen for EPOLLOUT.
> Reading is same, but you'd wait for EPOLLIN.

I've got a few questions about this approach.  The most logical 
way to do this seems to be:

1) Leave the epoll_wait with the EPOLLIN|EPOLLOUT event flags and
 use epoll_ctl to switch the interest mask for each fd between EPOLLIN 
and EPOLLOUT on a per fd basis.

2) When I'm ready to write, I do a write and if it does not fully 
write and I get the EAGAIN flag, I switch the fd with epoll_ctl(fd,MOD,EPOLLOUT). 

However, I get strange behavior when I tried adding fd's with only the 
EPOLLIN interest mask. If I use epoll_wait with both the EPOLLIN and 
EPOLLOUT interest mask, but add fd's with only the EPOLLIN interest mask,
I still seem to get EPOLLOUT events on the fd.

Am I supposed to change the main loop with epoll_wait so that when one 
socket is reading that I switch the main loop to get EPOLLOUT events?  
That means that I'm not receiving on any fd while I'm sending, so this 
probably isn't right.

So, I'm a little confused.

Thanks in advance.

Paul



      
