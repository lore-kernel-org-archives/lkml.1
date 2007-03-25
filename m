Return-Path: <linux-kernel-owner+w=401wt.eu-S1751104AbXCYKcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104AbXCYKcA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 06:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXCYKcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 06:32:00 -0400
Received: from max.feld.cvut.cz ([147.32.192.36]:57691 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbXCYKb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 06:31:58 -0400
From: CIJOML <cijoml@volny.cz>
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: HID OOPS running hid2hci on logitech diNovo dongle
Date: Sun, 25 Mar 2007 12:31:42 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200703251027.41441.cijoml@volny.cz> <Pine.LNX.4.64.0703251214421.29565@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0703251214421.29565@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703251231.42776.cijoml@volny.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with bluez-utils-3.9 dongle switches itself to hci mode. Only problem is that 
I see this oops, but dongle normally works, can communicate with my BT 
keyboard, mouse, mobile and also printer.

hci1:   Type: USB
        BD Address: 00:07:61:46:8F:98 ACL MTU: 1017:8 SCO MTU: 64:0
        UP RUNNING PSCAN
        RX bytes:695 acl:0 sco:0 events:23 errors:0
        TX bytes:336 acl:0 sco:0 commands:23 errors:0
        Features: 0xff 0xff 0x8d 0xfe 0x9b 0xf9 0x00 0x80
        Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
        Link policy: RSWITCH HOLD SNIFF PARK
        Link mode: SLAVE ACCEPT
        Name: 'notas-1'
        Class: 0x3e0100
        Service Classes: Networking, Rendering, Capturing, Object Transfer, 
Audio
        Device Class: Computer, Uncategorized
        HCI Ver: 2.0 (0x3) HCI Rev: 0x2000 LMP Ver: 2.0 (0x3) LMP Subver: 
0x4147
        Manufacturer: Broadcom Corporation (15)

notas:/usr/src/dinovo/bluez-utils-3.9# hciconfig hci1 features
hci1:   Type: USB
        BD Address: 00:07:61:46:8F:98 ACL MTU: 1017:8 SCO MTU: 64:0
        Features: 0xff 0xff 0x8d 0xfe 0x9b 0xf9 0x00 0x80
                <3-slot packets> <5-slot packets> <encryption> <slot offset>
                <timing accuracy> <role switch> <hold mode> <sniff mode>
                <park state> <RSSI> <channel quality> <SCO link> <HV2 packets>
                <HV3 packets> <u-law log> <A-law log> <CVSD> <power control>
                <transparent SCO> <broadcast encrypt> <EDR ACL 2 Mbps>
                <EDR ACL 3 Mbps> <enhanced iscan> <interlaced iscan>
                <interlaced pscan> <inquiry with RSSI> <extended SCO>
                <EV4 packets> <EV5 packets> <AFH cap. slave>
                <AFH class. slave> <3-slot EDR ACL> <5-slot EDR ACL>
                <AFH cap. master> <AFH class. master> <EDR eSCO 2 Mbps>
                <EDR eSCO 3 Mbps> <3-slot EDR eSCO> <extended features>
notas:/usr/src/dinovo/bluez-utils-3.9# hciconfig hci1 revision
hci1:   Type: USB
        BD Address: 00:07:61:46:8F:98 ACL MTU: 1017:8 SCO MTU: 64:0
        Firmware 0.65 / 71


Michal

Dne nedìle 25 bøezen 2007 12:18 Jiri Kosina napsal(a):
> On Sun, 25 Mar 2007, CIJOML wrote:
> > in combination of kernel 2.6.20-mh1 and hid2hci from bluez-utils-3.9 I
> > am getting following OOPS:
> > BUG: at drivers/hid/hid-core.c:785 implement()
> >  [<c027a9c3>] hid_output_report+0x213/0x2be
> >  [<fcaf73fb>] hid_submit_ctrl+0x52/0x1bc [usbhid]
> >  [<fcaf76b9>] usbhid_submit_report+0x154/0x187 [usbhid]
> >  [<fcaf7970>] usbhid_init_reports+0x60/0xbb [usbhid]
> >  [<fcaf917d>] hiddev_ioctl+0x361/0x8e7 [usbhid]
> >  [<c01b4dd1>] avc_has_perm+0x4e/0x58
> >  [<c01b5595>] inode_has_perm+0x5b/0x63
> >  [<c0148652>] __handle_mm_fault+0x2c3/0x7b1
> >  [<c01b5626>] file_has_perm+0x89/0x91
> >  [<c0161158>] do_ioctl+0x4c/0x62
> >  [<c01613aa>] vfs_ioctl+0x23c/0x24f
> >  [<c0161409>] sys_ioctl+0x4c/0x67
> >  [<c0102cc8>] syscall_call+0x7/0xb
> >  [<c02d0033>] __sched_text_start+0x43/0x546
>
> This is known bug that happens with recent Logitech dongles. Please see
> http://lkml.org/lkml/2007/2/16/215 and http://lkml.org/lkml/2007/3/5/274
>
> The problem here is that Logitech probably changed the way how the dongle
> is switched from HID to HCI mode, and bluez-utils don't support it (and
> send report that is not compliant with report descriptor of the dongle,
> which triggers this warning).
>
> Are you able to verify whether this could be possibly caused solely by
> newer versions of bluez-utils, as Amedee stated in some of the threads
> above?
