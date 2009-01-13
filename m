Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbZAMVUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbZAMVUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:20:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZAMVUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:20:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:9373 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZAMVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:20:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P1NDWGPGKFRZuoX72ebv23RxLSlGYRsG+XLjOy6TJ+9vLFokwVhu7g8xis2E8cyJDc
         bO/6tIl4UEBzlwkE6AFerb75HM5xFpnddiizvMAOPYGV0HraznB9N0+OS22j/U623k0D
         nGk8JtOyu/xxdcC0s5JzEJxf6uRpFrYq3V1kE=
Message-ID: <8db1092f0901131320k12139364y2d503b48f4d28100@mail.gmail.com>
Date: Tue, 13 Jan 2009 22:20:11 +0100
From: "Maciej Rutecki" <maciej.rutecki@gmail.com>
To: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [2.6.29-rc1] Problem with using bluetooth adaper connected to usb port
In-Reply-To: <8db1092f0901131034i62780d1fu37459186619e74ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8db1092f0901131034i62780d1fu37459186619e74ee@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/13 Maciej Rutecki <maciej.rutecki@gmail.com>:
> Until 2.6.28 I use hci_usb driver to bluetooth adapter. In 2.6.29-rc1
> it doesn't exists, so I switch to btusb module, and I have problem
> connect with another machine, dmesg shows this message:
> [  101.468638] hci_cmd_task: hci0 command tx timeout
> [  699.328112] hci_cmd_task: hci0 command tx timeout
>
> How to check what cause problems with communication?
>
> Contents /proc/bus/usb/devicec, dmesg, lsusb, config:
> http://www.unixy.pl/maciek/download/kernel/2.6.29-rc1/bluetooth/
>

hcidump in local interface

local hci0: 00:11:67:CA:45:0E
remote hci0: 00:16:41:88:A0:1B

Connection from local to remote (I use kdebluetoothd):
root@zlom:/home/maciek# hcidump -V -i hci0
HCI sniffer - Bluetooth packet analyzer ver 1.42
device: hci0 snap_len: 1028 filter: 0xffffffff
< HCI Command: Inquiry (0x01|0x0001) plen 5
    lap 0x9e8b33 len 8 num 0
> HCI Event: Command Status (0x0f) plen 4
    Inquiry (0x01|0x0001) status 0x00 ncmd 1
> HCI Event: Inquiry Result with RSSI (0x22) plen 15
    bdaddr 00:16:41:88:A0:1B mode 2 clkoffset 0x7468 class 0x100000 rssi -76
> HCI Event: Inquiry Complete (0x01) plen 1
    status 0x00
< HCI Command: Create Connection (0x01|0x0005) plen 13
    bdaddr 00:16:41:88:A0:1B ptype 0xcc18 rswitch 0x01 clkoffset 0x7468 (valid)
    Packet type: DM1 DM3 DM5 DH1 DH3 DH5
< HCI Command: Create Connection Cancel (0x01|0x0008) plen 6
    bdaddr 00:16:41:88:A0:1B
> HCI Event: Command Complete (0x0e) plen 10
    Create Connection Cancel (0x01|0x0008) ncmd 1
    status 0x02 bdaddr 1B:01:A5:B5:88:EC
    Error: Unknown Connection Identifier

>From remote to local:
root@zlom:/home/maciek# hcidump -V -i hci0
HCI sniffer - Bluetooth packet analyzer ver 1.42
device: hci0 snap_len: 1028 filter: 0xffffffff
> HCI Event: Connect Request (0x04) plen 10
    bdaddr 00:16:41:88:A0:1B class 0x100000 type ACL
< HCI Command: Accept Connection Request (0x01|0x0009) plen 7
    bdaddr 00:16:41:88:A0:1B role 0x01
    Role: Slave
> HCI Event: Connect Complete (0x03) plen 11
    status 0x10 handle 0 bdaddr 00:16:41:88:A0:1B type ACL encrypt 0x00
    Error: Connection Accept Timeout Exceeded

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
