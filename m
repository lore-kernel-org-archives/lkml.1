Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbXDXJT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbXDXJT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 05:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754620AbXDXJT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 05:19:57 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3294 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbXDXJT4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 05:19:56 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: sendfile to nonblocking socket
Date: Tue, 24 Apr 2007 02:19:49 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEDFDEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <462D8D92.9050301@amhost.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 24 Apr 2007 03:20:08 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 24 Apr 2007 03:20:10 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> David Schwartz пишет:
> > You have a misunderstanding about the semantics of 'sendfile'. 
> The 'sendfile' function is just a more efficient version of a 
> read followed by a write. If you did a read followed by a write, 
> it would block as well (in the read).
> >
> > DS

> sendfile function is not just a more efficient version of a read 
> followed by a write.  It reads from one fd and write to another at tha 
> same time. Please try to read 2G, and then write 2G - and how much 
> memory you will be need and how much time you will loose while reading 
> 2G from disk, but not writing them to socket.

You are correct. What I meant to say was that it's just a more efficient version of 'mmap'ing a file and then 'write'ing from the 'mmap'. The 'write' to a non-blocking socket can still 'block' on disk I/O.

> If you know more 
> efficient method to transfer file from disk to network - please advise. 
> Now all I want is really non-blocking sendfile. Currently sendfile is 
> non-blocking on network, but not on disk i/o. And when I have network 
> faster than disk - I get block.

There are many different techniques and which is correct depends on what direction you want to go. POSIX asynchronous I/O is one possibility. Threads plus epoll is another. It really depends upon how much performance you need, how much complexity you can tolerate, and how portable you need to be.

DS


