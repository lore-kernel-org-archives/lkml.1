Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZIBIsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZIBIsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 04:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbZIBIsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 04:48:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:48207 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbZIBIsN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 04:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=g0JlV6WniZkfa/LIJsmaaOs2YdX0aXhtA3/f7fq/9SssBvmIJ+IelquEjTwYR8w9VN
         ivuh0hRDYi8nSgeg2aFRdVsGuxXO72qGcmRo4fPx7DdVrftILZyVujBgFEK0AAhN6tQt
         j6xJ/k0Ynbw4NnwYiR4gBoclbI97Pgq3ND6ug=
MIME-Version: 1.0
In-Reply-To: <FCCFB4CDC6E5564B9182F639FC35608702F9AF18CF@dbde02.ent.ti.com>
References: <FCCFB4CDC6E5564B9182F639FC35608702F9A4570A@dbde02.ent.ti.com>
	 <FCCFB4CDC6E5564B9182F639FC35608702F9AF18CF@dbde02.ent.ti.com>
Date: Wed, 2 Sep 2009 14:10:50 +0530
Message-ID: <d6a0f7aa0909020140r46136dddgbfba29606e750a36@mail.gmail.com>
Subject: Re: [RFC][PATCH]: Adding support for omap-serail driver
From: Govindraj <govindraj.ti@gmail.com>
To: "Pandita, Vikram" <vikram.pandita@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vikram,


> What about UART3 supporting IRDA and CIR modes?
> Is that planned to be added?
>

We do have an driver to support IrDA -- > drivers/net/irda/omap-ir.c


>>+static unsigned int check_modem_status(struct uart_omap_port *up)
>
> What is the use case for modem_status?

This is basically used to handle any change in uart line[cts,dcd],
like an change in status of cts line should be handled
which is done using the function by checking the MSR[modem status register].

>>+              if (jiffies_to_msecs(jiffies - up_activity) < 10000) {
>>+                      mod_timer(&up->uart_dma.rx_timer, jiffies +
>>+                              usecs_to_jiffies(up->uart_dma.rx_timeout));
>
> Is this a 10 second timeout? Is this acceptable way?
> This has to be done in conjunction with the inactivity timer in mach-omap2/serial.c

This timeout is the period where we except some activity on rx line as
we dont the time period we receive data hence we keep rx dma channel
active for minimum of 10 secs, however this can be reduced.


-----
Regards,
Govindraj.R
