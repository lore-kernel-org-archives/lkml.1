Return-Path: <linux-kernel-owner+w=401wt.eu-S965227AbXBQM3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965227AbXBQM3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 07:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965224AbXBQM3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 07:29:55 -0500
Received: from webmail19.mail.yandex.net ([213.180.200.53]:35701 "EHLO
	webmail19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965228AbXBQM3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 07:29:54 -0500
Date: Sat, 17 Feb 2007 15:29:31 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D6F52B.000003.10185@webmail19.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: linux-kernel@vger.kernel.org
Subject: buffer overflows in the tty flip buffer in 2.6.17
X-MsgDayCount: 3
X-BornDate: 1134853200
Reply-To: Mockern@yandex.ru
X-Source-Ip: 84.185.244.133
Content-Type: text/plain;
  charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When data is received from the hardware, it needs to be placed into the tty device's flip buffer. This can be done with the following bit of code:

for (i = 0; i < data_size; ++i) {
        if (tty->flip.count >= TTY_FLIPBUF_SIZE)
                tty_flip_buffer_push(tty);
        tty_insert_flip_char(tty, data[i], 0);
}
tty_flip_buffer_push(tty);

This example makes sure there are no buffer overflows in the tty flip buffer as the data is being added. 

But how it is done in 2.6.17 linux kernel? I did check this "overflow code" in new tty driver's code. This code looks like just removed. But somehow overflow in the tty buffer must be kept.
