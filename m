Return-Path: <linux-kernel-owner+w=401wt.eu-S1752160AbXBWIHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbXBWIHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 03:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbXBWIHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 03:07:17 -0500
Received: from webmail12.mail.yandex.net ([213.180.223.102]:55632 "EHLO
	webmail12.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbXBWIHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 03:07:15 -0500
Date: Fri, 23 Feb 2007 11:06:48 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45DEA098.000003.11666@webmail12.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: cat reading problem 
X-MsgDayCount: 1
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.219.92
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I tried to cat < /dev/mytty/ttyS3, but cat shows nothing. I attached here strace
  
cat < /dev/mytty/ttyS3 and cat < hello. Hello is just a file. As you can see the 

result of strace cat is identical, but in tty case I can't see nothing. Why does cat write nothing at my console?

Thank you, 

------------------------------------------------------------------------------------

root@test:/home# strace cat  < hello
………………………………..
munmap(0x40017000, 5664)                = 0
getuid32()                              = 0
getgid32()                              = 0
setgid32(0)                             = 0
setuid32(0)                             = 0
read(0, "Hello World!", 8192)           = 12
write(1, "Hello World!", 12Hello World!)            = 12
read(0, "", 8192)                       = 0
io_submit(0, 0x40200164, 0 <unfinished ... exit status 0>
Process 1520 detached
root@test:/home# strace cat  < /dev/mytty/ttyS3
………………………………….
getuid32()                              = 0
getgid32()                              = 0
setgid32(0)                             = 0
setuid32(0)                             = 0
read(0, "\376\377\377f\377\330\0000", 8192) = 8
write(1, "\376\377\377f\377\330\0000", 8■ f0) = 8
read(0, "", 8192)                       = 0
io_submit(0, 0x40200164, 0 <unfinished ... exit status 0>
Process 1522 detached
root@test:/home#
