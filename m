Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYLBNv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYLBNv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:51:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYLBNvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:51:17 -0500
Received: from torres.zugschlus.de ([85.214.68.41]:58288 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbYLBNvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:51:17 -0500
X-Greylist: delayed 1974 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2008 08:51:16 EST
Date: Tue, 2 Dec 2008 14:18:21 +0100
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: linux-kernel@vger.kernel.org
Subject: pl2303 - pl2303_open - failed submitting interrupt urb, error -28
Message-ID: <20081202131821.GA25217@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the following applies to a "vanilla" 2.6.27.7 kernel built and running
on a Debian unstable system.

To obtain out-of-band access to a number of switches and routers, I
have a seven-port USB hub to which seven identical USB-to-serial
adaptors using the PL2303 chip and driver are connected. All seven
work when only one of them is used at a time.

Cereal is an application which keeps a process (GNU screen) attached
to the tty at all times to be able to log what happens on the serial
port. When I start cereal on all seven ports, I start getting
"pl2303_open - failed submitting interrupt urb, error -28" errors in
my syslog:

Dec  2 14:07:36 alemana kernel: pl2303 ttyUSB2: pl2303_open - failed submitting interrupt urb, error -28
Dec  2 14:07:37 alemana kernel: pl2303 ttyUSB5: pl2303_open - failed submitting interrupt urb, error -28
Dec  2 14:07:38 alemana kernel: pl2303 ttyUSB6: pl2303_open - failed submitting interrupt urb, error -28
Dec  2 14:07:41 alemana kernel: pl2303 ttyUSB2: pl2303_open - failed submitting interrupt urb, error -28
Dec  2 14:07:43 alemana kernel: pl2303 ttyUSB5: pl2303_open - failed submitting interrupt urb, error -28
Dec  2 14:07:43 alemana kernel: pl2303 ttyUSB6: pl2303_open - failed submitting interrupt urb, error -28
Dec  2 14:07:47 alemana kernel: pl2303 ttyUSB2: pl2303_open - failed submitting interrupt urb, error -28
Dec  2 14:07:48 alemana kernel: pl2303 ttyUSB5: pl2303_open - failed submitting interrupt urb, error -28
Dec  2 14:07:49 alemana kernel: pl2303 ttyUSB6: pl2303_open - failed submitting interrupt urb, error -28

The corresponding ports are not useable in that case.

When one googles for this error message, one finds a thread from 2006
with Greg KH commenting. In my case, the error doesn't hose the USB
subsystem, I can unplug the adapters and plug them in again one and a
time without a problem, and I can even use the ports that don't throw
this error message.

As in the 2006 thread, unloading the EHCI driver (ehci_hcd) solves the
issue, but is of course not an attractive option as soon as one wants
to use even a USB stick on the same machine.

If it helps, I can give out root access to the box in question to
anybody who is willing to help and debug. Unfortunately, I cannot
provide any expertise here, I do not even know what an interrupt urb is.

Any hints will be appreciated.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
