Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbXENQKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbXENQKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 12:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbXENQKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 12:10:35 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:55476 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122AbXENQKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 12:10:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=H7q/nIYODsTGUF+oGFEWp4w3IqVesswDJcOfQ2JIyMJ8DoNyFjrs8Tw79tgppU78MD0+17mBc3qwlmL6CX9EODIvJNgZpfsAHix6FOrdcuBWoOdpYYw17Uuv/3UjM3aaPUWniwNrkxIihF/ONjK3VoTbb1nxbc2nZGz3PsXWbrU=
Message-ID: <35fbaa3e0705140910s19feac4bnd71a80f25dc4753c@mail.gmail.com>
Date: Mon, 14 May 2007 19:10:33 +0300
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: USB adutux device number
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm not sure if it's correct place to deal with the issue.

In Documentation/devices.txt there is no info about adutux driver that
is included in the kernel:
...
		 65 = /dev/usb/usblcd	USBLCD Interface (info@usblcd.de)
		 66 = /dev/usb/cpad0	Synaptics cPad (mouse/LCD)
		 96 = /dev/usb/hiddev0	1st USB HID device
		    ...
...

The driver itself includes the following (drivers/usb/misc/adutux.c):

#ifdef CONFIG_USB_DYNAMIC_MINORS
#define ADU_MINOR_BASE	0
#else
#define ADU_MINOR_BASE	67
#endif

We need to update Documentation/devices.txt with this information. The
number of devices is 16.

I found an old mail tread for this:
http://www.uwsg.iu.edu/hypermail/linux/kernel/0609.3/2173.html
But I don't see anything related to adu devices in devices.txt at all.

Please let me know what is the reason of this. If needed I will create
a patch for this.

-- V
