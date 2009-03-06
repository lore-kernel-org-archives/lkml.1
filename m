Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbZCFWmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbZCFWmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbZCFWlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:41:39 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:35400 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850AbZCFWli convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:41:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FoWABBaX0a7CtFDXOstkuIfvau5moauYI0Wz0NLnS9DHElaElebSASLSQdjPlOykWZ
         lyUQsJ27vGK+Md7Sx4aoJKhrGvTx8Z0bdfrhRG9ql2ICxMQRyOv9MVNaw4XEKPIG4w39
         x6ovK48dYF2GUTWgGNjSRH26QD8E61Fv/Ljh4=
MIME-Version: 1.0
In-Reply-To: <20090306143821.268b7f00.akpm@linux-foundation.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	 <1236321780-28718-15-git-send-email-cooloney@kernel.org>
	 <20090306143821.268b7f00.akpm@linux-foundation.org>
Date: Fri, 6 Mar 2009 17:41:35 -0500
Message-ID: <8bd0f97a0903061441o2f3f313aib98580f3f2c18e0@mail.gmail.com>
Subject: Re: [PATCH 14/18] Blackfin Serial Driver: use the DLAB macro to hide 
	variant differences
From: Mike Frysinger <vapier.adi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 17:38, Andrew Morton wrote:
> On Fri,  6 Mar 2009 14:42:56 +0800 Bryan Wu wrote:
>> From: Mike Frysinger <vapier.adi@gmail.com>
>>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/serial/bfin_5xx.c |    8 ++------
>>  1 files changed, 2 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
>> index b89861d..71a9e6b 100644
>> --- a/drivers/serial/bfin_5xx.c
>> +++ b/drivers/serial/bfin_5xx.c
>> @@ -1250,7 +1250,7 @@ struct console __init *bfin_earlyserial_init(unsigned int port,
>>  void bfin_serial_debug(const char *fmt, ...)
>>  {
>>       struct bfin_serial_port *uart = &bfin_serial_ports[0];
>> -     unsigned short status, tmp;
>> +     unsigned short status;
>>       unsigned long flags;
>>       int i, count;
>>       char buf[128];
>> @@ -1273,11 +1273,7 @@ void bfin_serial_debug(const char *fmt, ...)
>>                       status = UART_GET_LSR(uart);
>>               } while (!(status & THRE));
>>
>> -#ifndef CONFIG_BF54x
>> -             tmp = UART_GET_LCR(uart);
>> -             tmp &= ~DLAB;
>> -             UART_PUT_LCR(uart, tmp);
>> -#endif
>> +             UART_CLEAR_DLAB(uart);
>>               UART_PUT_CHAR(uart, buf[i]);
>>               if (buf[i] == '\n') {
>>                       do {
>
> This appears to be a small cleanup, not a bugfix.
>
> I'm OK with sneaking the odd non-bugfix into late -rc by accident -
> it's not teribly important, and getting the main bugs fixed overwhelms
> such considerations.
>
> However I have a sneaky suspicion that this patch might actually fix a
> bug, only we weren't told about it?

fixes an unused var warning.  not really a "bug", but ...
-mike
