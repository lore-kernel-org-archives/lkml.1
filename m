Return-Path: <linux-kernel-owner+w=401wt.eu-S1750790AbXBQPw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750790AbXBQPw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 10:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbXBQPw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 10:52:26 -0500
Received: from mfront7.mail.yandex.net ([213.180.223.96]:33499 "EHLO
	mfront7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXBQPwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 10:52:25 -0500
Date: Sat, 17 Feb 2007 18:52:03 +0300 (MSK)
From: "Mockern" <Mockern@yandex.ru>
Message-Id: <45D724A3.000002.25611@mfront7.yandex.ru>
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ]
To: lsorense@csclub.uwaterloo.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: buffer overflows in the tty flip buffer in 2.6.17
X-MsgDayCount: 6
X-BornDate: 1134853200
In-Reply-To: <20070217151729.GS7584@csclub.uwaterloo.ca>
Reply-To: Mockern@yandex.ru
References: <45D6F52B.000003.10185@webmail19.yandex.ru> <20070217151729.GS7584@csclub.uwaterloo.ca>
X-Source-Ip: 84.185.244.133
Content-Type: text/plain;
  charset="KOI8-R"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanx for your respond. 

Could you please inform me what patches exactly you have grabbed?

>On Sat, Feb 17, 2007 at 03:29:31PM +0300, Mockern wrote:
>> When data is received from the hardware, it needs to be placed into the tty device's flip buffer. This can be done with the following bit of code:
>> 
>> for (i = 0; i < data_size; ++i) {
>>         if (tty->flip.count >= TTY_FLIPBUF_SIZE)
>>                 tty_flip_buffer_push(tty);
>>         tty_insert_flip_char(tty, data[i], 0);
>> }
>> tty_flip_buffer_push(tty);
>> 
>> This example makes sure there are no buffer overflows in the tty flip buffer as the data is being added. 
>> 
>> But how it is done in 2.6.17 linux kernel? I did check this "overflow code" in new tty driver's code. This code looks like just removed. But somehow overflow in the tty buffer must be kept.
>
>Well there was a problem in 2.6.16, which was fixed by 2.6.18, although
>I am not sure if it was done by 2.6.17.  It would loose characters due
>to buffer overflow and not properly checking under high load.  I grabbed
>a few patches from the git tree that were added after 2.6.16 to fix the
>tty problems I was having.
>
>--
>Len Sorensen
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Сегодня удачный день, чтобы завести почту на Яндексе http://mail.yandex.ru
