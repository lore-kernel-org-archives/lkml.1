Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYISPd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYISPd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbYISPdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:33:47 -0400
Received: from web26208.mail.ukl.yahoo.com ([217.12.10.245]:20418 "HELO
	web26208.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750927AbYISPdq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:33:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=26NYPtgzzkOeWcdMIgYOzj4Al4ufEVYj+tJFGx6F/3zSpow/zOxsntH0lo59T1T7mFE+QdDgE+dpVhWKoWfSK3Ykx9jS7o4rUcKI4ZGgbINlmIqV1L86aMQNTQ3Cu+f9XKoG05eOEmL2modpkVB7adQpKCCTJRuuMHzRKt1hz/c=;
X-YMail-OSG: zh1SAHEVM1lMkPav0nnI3GDjHF85jX0a8050UdEpfMZBmICPZytZoQlBk4pYKHgUY13RDeXxN5lzAtT_36Nd_Yk7pkYAbR84iqZoOD0uym8BloHrdv0zlCS2arKMI8BPCf5pO53kozUNo8XTaJc-
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Fri, 19 Sep 2008 15:33:44 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] atmel_serial: update the powersave handler to match serial core
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>,
       Anti Sullin <anti.sullin@artecdesign.ee>,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <393.6138.qm@web26208.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,




> +    /* we can not wake up if we're running on slow clock */
> +    atmel_port->may_wakeup = device_may_wakeup(&pdev->dev);
> +    if (atmel_serial_clk_will_stop())
> +        device_set_wakeup_enable(&pdev->dev, 0);
> +
This is not true, the wakeup in the slow clock is possible, configure the
input pin of the serial device as a gpio, and wake up on gpio. Then you
must reconfigure as a serial pin, and you can wake up on slow clock.

Regards Michael

__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
