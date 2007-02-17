Return-Path: <linux-kernel-owner+w=401wt.eu-S1946640AbXBQL2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946640AbXBQL2N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 06:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946648AbXBQL2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 06:28:12 -0500
Received: from mfront8.mail.yandex.net ([213.180.223.98]:56935 "EHLO
	mfront8.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946640AbXBQL2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 06:28:10 -0500
Date: Sat, 17 Feb 2007 14:27:51 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D6E6B7.000003.09194@mfront8.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux tty driver question
X-MsgDayCount: 2
X-BornDate: 1134853200
In-Reply-To: <45D6E094.8030006@gmail.com>
Reply-To: Mockern@yandex.ru
References: <45D6D3A3.000001.04520@tide.yandex.ru> <45D6E094.8030006@gmail.com>
X-Source-Ip: 84.185.244.133
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you, 

I have no problem with my tty driver, except one thing: it does not work with cat (but there are no problems to write,read from user space application). I'll try to follow your adwise to support cat. 


>Mockern napsal(a):
>> Hi,
>> 
>> I'm working on Linux tty driver (based on tiny_tty).
>> 
>> How can I provide in my driver Linux cat operation (e.g.cat < ttyS3)?
>
>call tty_insert_flip_*() from somewhere to put some data into tty recieve 
>buffer, which is pushed into ldisc by tty_flip_buffer_push() and then sent by 
>tty_read function (where ldisc read is called) to userspace for reading process.
>
>> What should I implement exactly?
>
>open, settermios, write_room (note that this is minimal and will probably oops 
>when poll or write is invoked) + some isr or timer to fill the buffer mentioned 
>above.
>
>regards,

-- 
Сегодня удачный день, чтобы завести почту на Яндексе http://mail.yandex.ru
