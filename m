Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbXBSPl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbXBSPl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbXBSPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:41:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:57918 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbXBSPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:41:28 -0500
From: "Daniel Stempel" <daniel.stempel@inat.de>
Subject: TCP timeout problem
To: linux-kernel@vger.kernel.org
Date: Mon, 19 Feb 2007 15:41:27 +0000
X-Priority: 3 (Normal)
Importance: normal
X-Mailer: DvISE by Tobit Software, Germany (0233.43484A4549464D4B4F4D), Mime Converter 101.20
X-David-Sym: 0
X-David-Flags: 0
Message-ID: <0004B32F.45D9D336@192.168.1.132>
MIME-Version: 1.0
Content-Type: text/plain;
 charset="iso-8859-1"
Content-Transfer-Encoding: 7Bit
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:895132d4fa561d9874c581248551c4a8
X-Provags-ID2: V01U2FsdGVkX199ByaVPuULjIqPfiXbIiWYqvW/GQzijIFJUrqAJgbC3LXBrAMkNgCdAbN3tbe5z8k9hel8WAGyiz5fVz60RAZexQQDYdT5R5DRTs/lxYOZbg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I need some advice concerning tcp-timeout behaviour.

I've got two devices communicating with eachother via TCP. Pulling the network cable from one of these devices interrpts the connection and it should timeout (timeout is set to e.g. 30 seconds). Thats where the problem lies. The connection does not timeout, because the keepalive_timer always gets reset by this piece of code:

:code begin:
/* It is alive without keepalive 8) */
if (tp->packets_out || tp->send_head)
    goto resched;
:code end:

(in tcp_timer.c -> tcp_keepalive_timer(unsigned long data))


A timeout never occurs and the connection will not terminate.

What is the reason for this behaviour (what exactly does this code do?) and is there any solution to this. If I delete the above mentioned code, timeout works fine. But changing proven kernel code is no appropriate solution. The kernel version I use is 2.4.18.

Thx in advance
Daniel Stempel


