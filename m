Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbYL1WZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbYL1WZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 17:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbYL1WYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 17:24:49 -0500
Received: from main.gmane.org ([80.91.229.2]:35456 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840AbYL1WYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 17:24:48 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: walt <w41ter@gmail.com>
Subject: Should <linux/serial.h> define __u32?
Date: Sun, 28 Dec 2008 14:24:36 -0800
Message-ID: <4957FCA4.4010201@gmail.com>
References: <20081010103447.31597.42992.stgit@localhost.localdomain> <20081010103637.31597.41557.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Linus Torvalds <torvalds@osdl.org>
X-Gmane-NNTP-Posting-Host: adsl-69-234-212-7.dsl.irvnca.pacbell.net
User-Agent: Thunderbird/3.0a2pre (X11; 2008122807)
In-Reply-To: <20081010103637.31597.41557.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan and Linus,

A little background to explain the reason for my question:

My linux distribution just updated /usr/include/linux to 2.6.28,
which broke the compilation of wine.

The cause for the breakage is this commit by Linus:
commit c26c56c0f40e200e61d1390629c806f6adaffbcc
Author: Alan Cox <alan@redhat.com>
Date:   Mon Oct 13 10:37:48 2008 +0100
     tty: Cris has a nice RS485 ioctl so we should steal it

That commit introduced this new struct in serial.h:

+struct serial_rs485 {
+       __u32   flags;                  /* RS485 feature flags */
+#define SER_RS485_ENABLED              (1 << 0)
+#define SER_RS485_RTS_ON_SEND          (1 << 1)
+#define SER_RS485_RTS_AFTER_SEND       (1 << 2)
+       __u32   delay_rts_before_send;  /* Milliseconds */
+       __u32   padding[6];             /* Memory is cheap, new structs
+                                          are a royal PITA .. */
+};

The proximate cause of the wine breakage is the __u32, which
wasn't used in serial.h until now.

So, my question is:  who should be responsible for defining
that __u32, the author of serial.h or the author of the wine
code that includes serial.h?

I'm not a professional programmer, just a hobbyist who loves
doing this stuff.  When I try to trace the chain of definitions
in /usr/include I'm generally overwhelmed by the complexity of
what seems to be an endless chain of includes.

Could you give me The Big Picture here?  (For example I'm assuming
that POSIX plays a confounding role in all of this, but I don't know
just how.)

Many thanks for any clues!


