Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbYJEWBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbYJEWBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbYJEWB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:01:27 -0400
Received: from daves.isp2dial.com ([69.60.113.26]:33545 "EHLO
	daves.isp2dial.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbYJEWB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:01:27 -0400
X-Greylist: delayed 1204 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Oct 2008 18:01:26 EDT
From: John Kelly <jak@isp2dial.com>
To: linux-kernel@vger.kernel.org
Subject: User credentials on a unix datagram socket
Date: Sun, 05 Oct 2008 21:41:22 +0000
Message-ID: <200810052141.m95LfL2c027165@isp2dial.com>
X-Mailer: Forte Agent 1.93/32.576 English (American)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Hard2Crack: 0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The socket(7) man page seems to imply that user credentials cannot be
sent on a unix datagram socket, unless socketpair() created it.

> SO_PEERCRED
>   Return the credentials of the foreign process connected to this socket.
>   This is only possible for connected AF_UNIX stream sockets and AF_UNIX
>   stream and datagram socket pairs created using socketpair(2);


But through trial and error, without reading any kernel source, I
learned that you can send user credentials on a regular unix datagram
socket which was not created with socketpair().

I'm unsure what SO_PEERCRED is intended for; I used SO_PASSCRED in my
server code, and it works.  I'm glad it does.  Stream sockets would
require a file descriptor for each client.  Ugh.  What I want to do is
so much simpler with datagram sockets.

I have sample code at ftp://ftp.isp2dial.com/users/jak/src/test/uxdg/

I hope someone will revise the man page and explain that you can pass
user credentials on a unix datagram socket, even one not created with
socketpair().

This is a very useful feature.  Please keep it in the kernel!


-- 
Webmail for Dialup Users
http://www.isp2dial.com/freeaccounts.html
 
