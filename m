Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXBQPD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXBQPD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965288AbXBQPD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:03:56 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:36677
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287AbXBQPD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:03:56 -0500
Message-ID: <45D71959.2010008@microgate.com>
Date: Sat, 17 Feb 2007 09:03:53 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Mockern@yandex.ru
CC: linux-kernel@vger.kernel.org
Subject: Re: line discipline and tty driver
References: <45D71555.000002.20869@webmail9.yandex.ru>
In-Reply-To: <45D71555.000002.20869@webmail9.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern wrote:
 > When it's necessary to use line discipline in tty driver
 > (to call ldisc.write(), ldisc.read(), ldisc.receive_buf())
 > and when I can ignore line discipline in my tty driver?

You should not call any of these from your driver.

transmit data is sent first to the line discipline
ldisc.write() which then calls into your driver write() method

your driver passes receive data to the ldisc through
the tty flip buffer functions.

--
Paul
