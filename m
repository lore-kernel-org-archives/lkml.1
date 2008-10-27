Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbYJ0Dsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbYJ0Dsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 23:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYJ0Dsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 23:48:36 -0400
Received: from web56306.mail.re3.yahoo.com ([216.252.110.230]:36199 "HELO
	web56306.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751328AbYJ0Dsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 23:48:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=RTIrt3CiWbGoQsSX2L/iKrwldkpgit8cxg93gcIodQGELvVs1+Ft5nWlzzJq/vs3Q3CPZhdFwcSfkK97TWi2zyd/WtUjoxL6T15aflI15qyT5/UuaXbZTYGODHxb7J42IJLWHtNmDH81rkXNwE8e4rTxYza/ip21/qNkwW7bKzo=;
X-YMail-OSG: C3yc6O8VM1lGyrN22OUhWmUbX.gp.FhwlI3Yt22_ErtU19dvt3HsrUOrvXa83e9Vq4vK62Mn5wJFcPgTqWMo95hRUVa.Ni9651k5Mosaa4qarLXDU5x6NPVu8uTsNVMeUbDlwi_x1UlR5XrwafxeRCmYHblcVzhf43m3Uhg-
X-Mailer: YahooMailWebService/0.7.247.3
Date: Sun, 26 Oct 2008 20:48:35 -0700 (PDT)
From: Paul P <ppak_98@yahoo.com>
Reply-To: ppak_98@yahoo.com
Subject: Re: unexpected extra pollout events from epoll
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810261812510.19212@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <420026.83313.qm@web56306.mail.re3.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which version of epoll do you have? The epoll_wait()
> function does not 
> accept an event mask (like you write above,
> EPOLLIN|EPOLLOUT). 

lol, I was a bit tired when I wrote that.  Ok, ignore the stuff related 
to epoll_wait in my previous post.
 
> As optimization, if the EPOLLOUT bit is already set, you
> don't need to 
> keep calling epoll_ctl(fd,MOD,EPOLLOUT).

This is good to know.

So, I've got a few questions about what happens to data that accumulates 
while I am sending and the fd is set to EPOLLOUT?  If I am send out a 
large buffer and incoming data wants to stream in on a full duplex 
connection, what happens to that data when I am processing the socket 
while it is in epollout mode?  

Is the following accurate?  When data comes in while I am sending, I guess 
the data fills up the receive buffers until they are full and then it 
stops accepting data until it is cleared out?  When I switch back to 
EPOLLIN, I'm guessing that I will get a notification on that fd that there 
is data waiting.

The other question I have is there a way to do full-duplex networking so 
that I can receive network messages while I am sending or vice versa?  It 
seems that the method of switching the socket between EPOLLIN and EPOLLOUT 
means that I can't do both operations simultaneously.  Thanks

Paul


      
