Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZGHLLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZGHLLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZGHLK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:10:57 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:53583 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbZGHLK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:10:56 -0400
From: Frans Pop <elendil@planet.nl>
To: Erik Ekman <erik@kryo.se>
Subject: Re: [PATCH -tip][RFC] serial8250: update to dev_pm_ops
Date: Wed, 8 Jul 2009 13:10:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Cox <alan@linux.intel.com>
References: <20090701083737.41f28c7d.erik@kryo.se>
In-reply-To: <20090701083737.41f28c7d.erik@kryo.se>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200907081310.53579.elendil@planet.nl>
X-OriginalArrivalTime: 08 Jul 2009 11:10:54.0932 (UTC) FILETIME=[C31F6940:01C9FFBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n68BBAXx020723

Adding some CCs as there's no reply yet.
> From dmesg:> Platform driver 'serial8250' needs updating - please use dev_pm_ops>> Is this how it should be done?
Alan or Rafael can probably tell.
One comment from me at the bottom.
> I have not tested it, but it compiles fine. Should I send in similar> patches for other drivers that also give this message?
Note that comments and questions that should not go in the commit logshould go between the separator after the Signed-off-by line and thepatch.
> Signed-off-by: Erik Ekman <erik@kryo.se>> ---
[Comments and questions go here]
>diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c>index fb867a9..dcbc6da 100644>--- a/drivers/serial/8250.c>+++ b/drivers/serial/8250.c>@@ -2982,42 +2982,46 @@ static int __devexit serial8250_remove(struct platform_device *dev)>        return 0;> }> >-static int serial8250_suspend(struct platform_device *dev, pm_message_t state)>+static int serial8250_suspend(struct device *dev)> {>        int i;> >        for (i = 0; i < UART_NR; i++) {>                struct uart_8250_port *up = &serial8250_ports[i];> >-               if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)>+               if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)>                        uart_suspend_port(&serial8250_reg, &up->port);>        }> >        return 0;> }> >-static int serial8250_resume(struct platform_device *dev)>+static int serial8250_resume(struct device *dev)> {>        int i;> >        for (i = 0; i < UART_NR; i++) {>                struct uart_8250_port *up = &serial8250_ports[i];> >-               if (up->port.type != PORT_UNKNOWN && up->port.dev == &dev->dev)>+               if (up->port.type != PORT_UNKNOWN && up->port.dev == dev)>                        serial8250_resume_port(i);>        }> >        return 0;> }> >+static struct dev_pm_ops serial8250_pm_ops = {>+       .suspend = serial8250_suspend,>+       .resume  = serial8250_resume,>+};>+> static struct platform_driver serial8250_isa_driver = {>        .probe          = serial8250_probe,>        .remove         = __devexit_p(serial8250_remove),>-       .suspend        = serial8250_suspend,>-       .resume         = serial8250_resume,>        .driver         = {>                .name   = "serial8250",>                .owner  = THIS_MODULE,>+               .pm     = &serial8250_pm_ops, 
Git warns that there is whitespace at the end of this line...
>        },> };
Cheers,FJPÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
