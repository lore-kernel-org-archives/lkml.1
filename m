Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbYGYT0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbYGYT0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 15:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYGYT0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 15:26:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:45680 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYGYT0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 15:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=AZVw990DUdvL794yYl+2icqO9tLCpGz5hnxLH2fKzU8bGj97JUzB4idmEhZoMvLbZR
         RUAd/HhiTgx1erh1zWWqWHZWfmDLCZuLpKveWofEIZoueuu28T1zX6F2nblIcqowU48o
         JYghFrI9qlJ8TMb5A4EzlSBY+jIwgjok2yWFs=
Message-ID: <488A28F3.6030100@gmail.com>
Date: Fri, 25 Jul 2008 15:26:43 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: mac@melware.de
CC: linux-kernel@vger.kernel.org
Subject: isdn/eicon: msg_in_{wrap,read}_pos assigned twice?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vi drivers/isdn/hardware/eicon/message.c +4035

and note two similar tests on line 4035 and 4049:

[else] if (plci->msg_in_read_pos == plci->msg_in_wrap_pos)

after the first test:

	plci->msg_in_wrap_pos = MSG_IN_QUEUE_SIZE;
	plci->msg_in_read_pos = i + MSG_IN_OVERHEAD;

but then after the second test as well:

	plci->msg_in_read_pos = MSG_IN_QUEUE_SIZE;
	plci->msg_in_wrap_pos = MSG_IN_QUEUE_SIZE;


So the assignment after the first test has no effect. Is this a bug?

Roel Kluin
