Return-Path: <linux-kernel-owner+w=401wt.eu-S1946714AbXBQNOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946714AbXBQNOk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 08:14:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946715AbXBQNOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 08:14:40 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:57620 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946714AbXBQNOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 08:14:39 -0500
Message-ID: <45D6FFC4.4030205@gmail.com>
Date: Sat, 17 Feb 2007 14:14:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Mockern@yandex.ru
Cc: linux-kernel@vger.kernel.org
Subject: Re: buffer overflows in the tty flip buffer in 2.6.17
References: <45D6F52B.000003.10185@webmail19.yandex.ru>
In-Reply-To: <45D6F52B.000003.10185@webmail19.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern napsal(a):
> When data is received from the hardware, it needs to be placed into the tty device's flip buffer. This can be done with the following bit of code:
> 

> for (i = 0; i < data_size; ++i) {
>         if (tty->flip.count >= TTY_FLIPBUF_SIZE)
>                 tty_flip_buffer_push(tty);
>         tty_insert_flip_char(tty, data[i], 0);
> }
> tty_flip_buffer_push(tty);

size = tty_buffer_request_room(tty, data_size);
tty_insert_flip_string(tty, data, min(data_size, size));
tty_flip_buffer_push(tty);
+ cope with size < data_size (some data_size -= size with 3 lines above in do {} 
while (data_size))

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
