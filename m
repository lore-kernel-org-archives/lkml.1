Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbYFZU4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbYFZU4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbYFZU4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:56:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:22925 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbYFZU4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=E0YTHD3V5ywgdLC56VuN0YECN+UFlW6IZpgKAFxGHC9PYioLDTUnNARK1EvRJEUQtY
         yE51DYBo2ItZ3/PDlCayPbPez0wHURUcA1dBo9ExHnBhA8LaPJeU1pkqZHINgtcwf4dS
         1GaC5vz+5m3DlDbgdWhqH2zm3cJg9JGV1Ijcs=
Message-ID: <48239d390806261356m57acbe4er4dd3d928c1493b88@mail.gmail.com>
Date: Fri, 27 Jun 2008 00:56:26 +0400
From: "Sergey Lapin" <slapinid@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Half-duplex rs-485 on full-duplex UART.
In-Reply-To: <48239d390806261343y6bafbefap6cdaaecaf1969a89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48239d390806261343y6bafbefap6cdaaecaf1969a89@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all!

I have a device with normal serial ports (at91sam9260-based) and
RS-485 half-duplex transceiver
installed for it and 1 GPIO for duplex control, 1=writing, 0=reading.
A problem is that I need to hack serial driver to support this GPIO
control, which I don't like.
I just need to set it to 1 before transmission and back to 0 when
transmission ends.

Most important thing is to set this bit to 1 before transfer starts,
so I can't just poll UART registers
from tasklet. So I had to hack into serial driver for that.

So questions are:

1. Is there some generic enough mechanism in kernel to handle such
tasks? so I mean external
serial transcievers support?

2. Is there any way to implement this task without touching, in my
case, drivers/serial/atmel_serial.c?

Thanks a lot,
S.
