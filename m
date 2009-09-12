Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZILMIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZILMIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 08:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZILMId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 08:08:33 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:56518 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZILMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 08:08:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=hd/j2fcCTvLbpYBESTKvGQgGLrePwpBFlRT6xe9vLJ2QE+CvN2cguF5YlbLP0cQYwl
         q/wltuBPE/lli3bXZXa8pRj2C65VTZD0ybFLyGcPGhgH03q3JhiRzQVdaam/yi2ZYNJj
         q+H/ZHf3+0Zeqgdg8NUduTnqEJ8rFiyQJtwc8=
Message-ID: <4AAB8F3F.40403@googlemail.com>
Date: Sat, 12 Sep 2009 14:08:31 +0200
From: e9hack <e9hack@googlemail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
Subject: Trouble with USB serial driver (ftdi_sio.c) on 2.6.31
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've some trouble with the USB serial driver (ftdi_sio.c for a FT232RL from FTDI). If the 
port is opened for the first time, the driver works perfectly. If the port is closed and 
open again, it isn't possible to read any data from port. Writing data to the port works. 
The FT232RL must be reconnect to get it working again. A reboot without reconnect doesn't 
solve this problem. If I look at the debug output, I don't see read requests from 
ftdi_sio.c. If reading is possible, I see this read messages:

...
Sep 12 13:36:21 vdr kernel: [  147.338926] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: Status only: 001o 000o
Sep 12 13:36:21 vdr kernel: [  147.339921] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_read_bulk_callback - port 0
Sep 12 13:36:21 vdr kernel: [  147.339927] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_process_read - port 0
Sep 12 13:36:21 vdr kernel: [  147.339930] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: Status only: 001o 000o
Sep 12 13:36:21 vdr kernel: [  147.340931] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_read_bulk_callback - port 0
Sep 12 13:36:21 vdr kernel: [  147.340936] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_process_read - port 0
Sep 12 13:36:21 vdr kernel: [  147.340940] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: Status only: 001o 000o
Sep 12 13:36:21 vdr kernel: [  147.341927] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_read_bulk_callback - port 0
Sep 12 13:36:21 vdr kernel: [  147.341932] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_process_read - port 0
Sep 12 13:36:21 vdr kernel: [  147.341936] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: Status only: 001o 000o
Sep 12 13:36:21 vdr kernel: [  147.342924] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_read_bulk_callback - port 0
Sep 12 13:36:21 vdr kernel: [  147.342928] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_process_read - port 0
Sep 12 13:36:21 vdr kernel: [  147.342932] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: Status only: 001o 000o
Sep 12 13:36:21 vdr kernel: [  147.343924] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_read_bulk_callback - port 0
Sep 12 13:36:21 vdr kernel: [  147.343929] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_process_read - port 0
Sep 12 13:36:21 vdr kernel: [  147.343933] ftdi_sio ttyUSB0: ftdi_process_read - length = 
7, data = 01 00 aa 40 0a 00 64
Sep 12 13:36:21 vdr kernel: [  147.344930] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_read_bulk_callback - port 0
Sep 12 13:36:21 vdr kernel: [  147.344936] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_process_read - port 0
Sep 12 13:36:21 vdr kernel: [  147.344940] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: Status only: 001o 000o
Sep 12 13:36:21 vdr kernel: [  147.345923] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_read_bulk_callback - port 0
Sep 12 13:36:21 vdr kernel: [  147.345928] 
/usr/src/linux-2.6.31-rc3/drivers/usb/serial/ftdi_sio.c: ftdi_process_read - port 0
...

This occurs with 2.6.31 and 2.6.31-rc3. I don't see this problem with 2.6.30.5. It exist 
one exception: If I reboot from 2.6.31 to 2.6.30.5, I get the same problem. If I reconnect 
the FT232RL, the FT232RL works perfectly. I don't see any problems after closing and 
reopening.

Regards,
Hartmut
