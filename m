Return-Path: <linux-kernel-owner+w=401wt.eu-S965167AbXBQLBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965167AbXBQLBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 06:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965170AbXBQLBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 06:01:35 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:36639 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965167AbXBQLBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 06:01:34 -0500
Message-ID: <45D6E094.8030006@gmail.com>
Date: Sat, 17 Feb 2007 12:01:40 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux tty driver question
References: <45D6D3A3.000001.04520@tide.yandex.ru>
In-Reply-To: <45D6D3A3.000001.04520@tide.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern napsal(a):
> Hi,
> 
> I'm working on Linux tty driver (based on tiny_tty).
> 
> How can I provide in my driver Linux cat operation (e.g.cat < ttyS3)?

call tty_insert_flip_*() from somewhere to put some data into tty recieve 
buffer, which is pushed into ldisc by tty_flip_buffer_push() and then sent by 
tty_read function (where ldisc read is called) to userspace for reading process.

> What should I implement exactly?

open, settermios, write_room (note that this is minimal and will probably oops 
when poll or write is invoked) + some isr or timer to fill the buffer mentioned 
above.

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
