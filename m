Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbXHZOh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbXHZOh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 10:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbXHZOhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 10:37:15 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51146 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbXHZOhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 10:37:14 -0400
Date: Sun, 26 Aug 2007 16:37:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-mtd@lists.infradead.org,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/30] mtd: Don't cast kmalloc() return value in
 drivers/mtd/maps/pmcmsp-flash.c
In-Reply-To: <200708261528.56250.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0708261635080.15614@fbirervta.pbzchgretzou.qr>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
 <9a8748490708251728h51d51092r11a3562ceb63b2f9@mail.gmail.com>
 <Pine.LNX.4.64.0708252021070.8721@localhost.localdomain>
 <200708261528.56250.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26 2007 15:28, Denys Vlasenko wrote:
>> >
>> > What exactely would using kcalloc() over kzalloc() here buy us?
>>
>> technically, nothing.
>
>The idea of calloc is that it can check for underflow in parameter.

Actually, overflow.

calloc(0xFFFF0000,  0x1000) => will return NULL
malloc(0xFFFF0000 * 0x1000) => silent 32 bit multiplication/truncation,
will allocate less than requested.

>calloc(-1, 10000000) => easy to detect
>malloc(-1 * 10000000) => malloc(-10000000) => not so trivial


	Jan
-- 
