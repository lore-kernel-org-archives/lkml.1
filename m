Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYISQBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYISQBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYISQBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:01:43 -0400
Received: from web26204.mail.ukl.yahoo.com ([217.12.10.241]:38498 "HELO
	web26204.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752617AbYISQBm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:01:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=YK7xpbf9yCOSa7dFZAvPMuhSGLFGdpdAmQNGt1bTVRp1jszkz9x1uYu97pgV3Z86/3AEkSun5aHjY663fSaMr0muUvsF2zXxIkTjuLIM8OYtGCk7nIisid7Bq/MDPTTHZ1ONnQWfRW+b1buPIDnPRA4ROJMrBGAHoXItsv4ZIgg=;
X-YMail-OSG: yRHLtdMVM1k9CETRbeHX4RnycMqZw6r4IOB2hBirRU_M0468u2OFcl5yubyY0u5nKqolVLHW8GOxkE4HIaKBQ_LYT32_IY1uOyXWlwJK0u18A62m9WyQZrZamLmOL1Omw_cuja8rX4t7sHBCV2Y-
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Fri, 19 Sep 2008 16:01:40 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] atmel_serial: update the powersave handler to match serial core
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>,
       Anti Sullin <anti.sullin@artecdesign.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <690570.15660.qm@web26204.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


(I'll change my mailer soon ...), sorry if I break the thread.


----- Messaggio originale -----
> Da: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> A: Michael Trimarchi <trimarchimichael@yahoo.it>
> Cc: linux-serial@vger.kernel.org; linux-kernel@vger.kernel.org; Andrew Victor <linux@maxim.org.za>; Anti Sullin <anti.sullin@artecdesign.ee>
> Inviato: Venerdì 19 settembre 2008, 17:46:15
> Oggetto: Re: [PATCH] atmel_serial: update the powersave handler to match serial core
> 
> Michael Trimarchi wrote:
> > > +    /* we can not wake up if we're running on slow clock */
> > > +    atmel_port->may_wakeup = device_may_wakeup(&pdev->dev);
> > > +    if (atmel_serial_clk_will_stop())
> > > +        device_set_wakeup_enable(&pdev->dev, 0);
> > > +  
> > This is not true, the wakeup in the slow clock is possible, configure the
> > input pin of the serial device as a gpio, and wake up on gpio. Then you
> > must reconfigure as a serial pin, and you can wake up on slow clock.
> 
> Yes, but the current driver doesn't actually support that, does it?
> 

Yes I know, but we can think about it and support when is possible
to wake-up the serial device. Each serial device can change the status
of the gpio-pin before suspendig and register and handler on it (I think one
interrupt handler for all the serial that can do that), then reset it after resume.
I think not all the serial device can do that in the atmel architectures but I suppose
that can be very usefull for example in gprs application.

> This patch doesn't really change that assumption anyway -- it just
> implements it in a way more consistent with the current serial core.
> 

> Haavard

Regards Michael

__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
