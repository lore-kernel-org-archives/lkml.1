Return-Path: <linux-kernel-owner+w=401wt.eu-S1764792AbXGJXkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764792AbXGJXkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763695AbXGJXkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:40:21 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:41273 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763310AbXGJXkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:40:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FOPGi0jKjaGaPTCBvtQlq8j3ubZAwBlAVOq7qnOHjl2myCTI5dBn5kaXm6WJO7fpBLRtXOk8e08pi9s1U7R6jKUXIZIpM4KiCSmcnhR0n3S6uHqJoKxsomgw1mZJSGJRf3P8W8ZPZNCWeVBbT2YHvYMBAotYzjx0o0csMNqWiT4=  ;
X-YMail-OSG: NTVk5.wVM1lSMpCNQ7eUjRk4x6.kOOuct8UXgEf8KLKhFLwkxntQwqpTeuhL1I1.Xmi79cQ2UA--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.22] gpio calls don't need i/o barriers
Date: Tue, 10 Jul 2007 16:18:10 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707101618.10361.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clarify that drivers using the GPIO operations don't need to issue
io barrier instructions themselves.  Previously this wasn't clear,
and at least one platform assumed otherwise (and would thus break
various otherwise-portable drivers which don't issue barriers).

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/gpio.txt |    3 +++
 1 file changed, 3 insertions(+)

--- g26.orig/Documentation/gpio.txt	2007-06-24 13:23:21.000000000 -0700
+++ g26/Documentation/gpio.txt	2007-06-24 13:32:01.000000000 -0700
@@ -75,6 +75,9 @@ using the include file:
 If you stick to this convention then it'll be easier for other developers to
 see what your code is doing, and help maintain it.
 
+Note that these operations include I/O barriers on platforms which need to
+use them; drivers don't need to add them explicitly.
+
 
 Identifying GPIOs
 -----------------
