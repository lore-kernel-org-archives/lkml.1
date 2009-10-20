Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbZJTRj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbZJTRj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 13:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbZJTRj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 13:39:56 -0400
Received: from mail.nuvation.com ([68.65.78.147]:2024 "EHLO
	mailguy3.skynet.nuvation.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751941AbZJTRjz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 13:39:55 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Oct 2009 13:39:55 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: FPGA Serial driver
Date: Tue, 20 Oct 2009 10:24:49 -0700
Message-ID: <274F7B50569A1B4C9D7BCAB17A9C7BE101D0036F@mailguy3.skynet.nuvation.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: FPGA Serial driver
Thread-Index: AcpRqjndYtZglXHYRsSj2e2DmjvVBA==
From: "Jerry Johns" <Jerry.Johns@nuvation.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
            I'm not exactly sure which mailing list to ask this, and am hoping that this list is the correct one for which this makes sense

I have an OMAP3530 mated to an FPGA over the GPMC interface (that maps external memory to a known linear space within the OMAP) found on that chip. I have an interrupt controller on the FPGA (and mapped into virtual IRQs in Linux through irqchip and chained handlers) and a few UARTs in it as well - the UART is specifically chosen to be 16550 compatible so that it can directly be mapped as a platform device into the 8250 serial platform driver. This way, I avoid having to write a serial driver, and it is directly compatible with that in Linux.

The FPGA currently is programmed by a separate device on boot, and that process can take up to 20 seconds - hence, the custom interrupt handler and serial driver in Linux cannot really be loaded until the FPGA has completed boot. At the same time, I do not want to hold-off booting Linux till the FPGA is alive.

What is the correct solution to this? Should I just load the interrupt and serial drivers anyways (and not use them till the FPGA is up) or should I defer loading them (that doesn't seem possible for the serial at least..)? 

Any ideas are much appreciated!

Thanks,
Jerry Johns
Design Engineer
Nuvation Research Corp - Canada

