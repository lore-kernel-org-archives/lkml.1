Return-Path: <linux-kernel-owner+w=401wt.eu-S936066AbXJSWmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936066AbXJSWmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757904AbXJSWmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:42:37 -0400
Received: from khc.piap.pl ([195.187.100.11]:44141 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855AbXJSWmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:42:37 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
	<m3d4vebylw.fsf@maximus.localdomain>
	<471527E5.1050407@s5r6.in-berlin.de>
	<m34pgpmszu.fsf@maximus.localdomain>
	<47166C83.2050207@s5r6.in-berlin.de>
	<m3fy09ffp9.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 20 Oct 2007 00:42:34 +0200
In-Reply-To: <m3fy09ffp9.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Thu, 18 Oct 2007 02:07:30 +0200")
Message-ID: <m3abqeybdx.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OTOH, it's no magic - they claim OHCI 1.1 and they do it. We don't
> only know how to enable it with (only) software. I suspect all those
> VT6306 could be "upgraded" as well.

BTW: I've looked at it a bit closer and it seems the EEPROM lines
are controlled by VT6307 I/O ports (region #1) 0x0 and 0x20:

01:04.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
		Controller (rev 80) (prog-if 10 [OHCI])
        Memory at feafe800 (32-bit, non-prefetchable) [size=2K]
        I/O ports at d480 [size=128]
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

port 0x20 R/O bit 8 is set in 93c46 mode and reset in I^2C mode
port 0x20 bit 4 must be set to drive CS, CLK and DATA-OUT outputs
port 0x20 bits 3, 2 and 1 are, respectively, CS, CLK and DATA-OUT
     pins in 93c46 mode and unused, SCL and SDA pins in I^2C mode
port 0x20 R/O bit 0 is DATA-IN input in 93c46 mode

port 0x0 bit 8 must be set to enable access
port 0x20 must be written 0x20 (bit 5 only) to disable access
     (clears port 0x0 bit 8).

They are all 32-bit I/O ports.

The above allows for complete control in 93c46 mode (I'll make the
program available later) and unfortunately I don't yet know how to
read SDA (and SCL) state in I^2C mode (I can blindly write to the
EEPROM and I can read the EEPROM data using GUID PROM register so
there is a workaround).
-- 
Krzysztof Halasa
