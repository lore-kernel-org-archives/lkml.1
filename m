Return-Path: <linux-kernel-owner+w=401wt.eu-S933263AbXGRPnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbXGRPnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 11:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759432AbXGRPnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 11:43:11 -0400
Received: from mail.novatech-llc.com ([64.126.95.172]:65317 "EHLO
	SERVER1.novatech.novatech-llc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759388AbXGRPnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 11:43:10 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 11:43:10 EDT
Thread-Index: AcfJUaJrzFrci7gNQRqqqFp+hxTJyg==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
Importance: normal
Content-Class: urn:content-classes:message
Message-ID: <469E332C.7050603@novatech-llc.com>
Date: Wed, 18 Jul 2007 10:35:08 -0500
From: "George McCollister" <georgem@novatech-llc.com>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: setserial -> serial_core / 8250 interaction
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jul 2007 15:38:05.0720 (UTC) FILETIME=[A261C980:01C7C951]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've recently found (using 2.6.21.4) that configuring a serial ports
(ST16654) which use the 8250 driver using setserial results in the
UART's FIFOs being disabled (unless you specify autoconfig).

The problem is that setserial doesn't fill out xmit_fifo_size when
calling TIOCSSERIAL to set the port type. There doesn't appear to be any
provision to set the port type and have 8250 use the default fifo_size
value for the selected FIFO from uart_config.

The result is that fifo_size remains 0 and the fifo is disabled. So, I
believe that anyone using setserial to configure a serial port (unless
autoconfig is used) will have very poor serial port performance (I did,
thats how I ran across this).

I haven't been able to think of a cure all solution without introducing
some pretty nasty changes. You could argue that setserial should set
xmit_fifo_size, but it seems unnecessary to require a user level program
to have knowledge of the FIFO sizes for all of the different UARTS. I'm
going to change my copy of 8250.c to always use fifo_size from
uart_config, but some people may not find this acceptable.

Maybe I'm missing something here, but I wanted to bring it up in case
its actually affecting other people.

I'm not subscribed to the list so if you reply please CC to my address.

Regards,
George McCollister


This message is for the designated recipient only and may contain
privileged, proprietary, or otherwise private information.  If you have
received it in error, please notify the sender immediately and delete
the original.  Any other use of the email by you is prohibited.


This message is for the designated recipient only and may contain
privileged, proprietary, or otherwise private information.  If you have
received it in error, please notify the sender immediately and delete
the original.  Any other use of the email by you is prohibited.
