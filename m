Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbYJ3VKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbYJ3VKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbYJ3VKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:10:07 -0400
Received: from archer.toppoint.de ([217.70.197.1]:47793 "EHLO mail.toppoint.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425AbYJ3VKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:10:05 -0400
Date: Thu, 30 Oct 2008 21:43:27 +0100
From: Wilfried Klaebe <linux-kernel@lebenslange-mailadresse.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.27.4, usb / dvb: possible recursive locking detected
Message-ID: <20081030204327.GA28790@kaos.in-kiel.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On booting, I noticed the following scrolling by:

[    0.000000] Linux version 2.6.27.4 (w@shubashi) (gcc version 4.3.2 (Debian 4.3.2-1) ) #3 Thu Oct 30 16:49:03 CET 2008

[    3.269100] usb 1-3: configuration #1 chosen from 1 choice
[    3.269759] hub 1-3:1.0: USB hub found
[    3.270243] hub 1-3:1.0: 4 ports detected

[    3.503581] usb 1-3: New USB device found, idVendor=05e3, idProduct=0608
[    3.503657] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.503720] usb 1-3: Product: USB2.0 Hub

[    4.103811] usb 1-3.1: new high speed USB device using ehci_hcd and address 4
[    4.188069] usb 1-3.1: configuration #1 chosen from 1 choice
[    4.189339] usb 1-3.1: New USB device found, idVendor=2040, idProduct=7070
[    4.189420] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.189496] usb 1-3.1: Product: Nova-T Stick
[    4.189559] usb 1-3.1: Manufacturer: Hauppauge
[    4.189615] usb 1-3.1: SerialNumber: 4031220072
[    4.257090] usb 1-3.2: new high speed USB device using ehci_hcd and address 5
[    4.350336] usb 1-3.2: configuration #1 chosen from 1 choice
[    4.351701] usb 1-3.2: New USB device found, idVendor=2040, idProduct=7070
[    4.351773] usb 1-3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.351857] usb 1-3.2: Product: Nova-T Stick
[    4.351913] usb 1-3.2: Manufacturer: Hauppauge
[    4.351974] usb 1-3.2: SerialNumber: 4031220114
[    4.431552] usb 1-3.3: new high speed USB device using ehci_hcd and address 6

[    4.519699] usb 1-3.3: configuration #1 chosen from 1 choice
[    4.521533] usb 1-3.3: New USB device found, idVendor=2040, idProduct=7070
[    4.521615] usb 1-3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.521692] usb 1-3.3: Product: Nova-T Stick
[    4.521749] usb 1-3.3: Manufacturer: Hauppauge
[    4.521805] usb 1-3.3: SerialNumber: 4031047903
[    4.600452] usb 1-3.4: new high speed USB device using ehci_hcd and address 7
[    4.684707] usb 1-3.4: configuration #1 chosen from 1 choice
[    4.687834] usb 1-3.4: New USB device found, idVendor=2040, idProduct=7060
[    4.687915] usb 1-3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.687987] usb 1-3.4: Product: Nova-T Stick
[    4.688043] usb 1-3.4: Manufacturer: Hauppauge
[    4.688098] usb 1-3.4: SerialNumber: 4028702181

[   19.863512] dib0700: loaded with support for 7 different device-types
[   19.867070] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[   19.867361] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   19.868108] DVB: registering new adapter (Hauppauge Nova-T Stick)
[   20.118891] DVB: registering frontend 0 (DiBcom 7000PC)...
[   20.153497] 
[   20.153509] =============================================
[   20.153632] [ INFO: possible recursive locking detected ]
[   20.153692] 2.6.27.4 #3
[   20.153743] ---------------------------------------------
[   20.153802] modprobe/1295 is trying to acquire lock:
[   20.153859]  (&adap->bus_lock){--..}, at: [<e80a5586>] i2c_transfer+0x86/0x90 [i2c_core]
[   20.154091] 
[   20.154093] but task is already holding lock:
[   20.154192]  (&adap->bus_lock){--..}, at: [<e80a5586>] i2c_transfer+0x86/0x90 [i2c_core]
[   20.154374] 
[   20.154376] other info that might help us debug this:
[   20.154476] 1 lock held by modprobe/1295:
[   20.154530]  #0:  (&adap->bus_lock){--..}, at: [<e80a5586>] i2c_transfer+0x86/0x90 [i2c_core]
[   20.154749] 
[   20.154751] stack backtrace:
[   20.154851] Pid: 1295, comm: modprobe Not tainted 2.6.27.4 #3
[   20.154914]  [<c038d53c>] ? printk+0x18/0x1c
[   20.155060]  [<c0148f22>] __lock_acquire+0x1342/0x1630
[   20.155172]  [<c038fced>] ? _spin_unlock+0x1d/0x20
[   20.155305]  [<c014926c>] lock_acquire+0x5c/0x80
[   20.155402]  [<e80a5586>] ? i2c_transfer+0x86/0x90 [i2c_core]
[   20.155534]  [<c038e59a>] mutex_lock_nested+0x9a/0x270
[   20.155630]  [<e80a5586>] ? i2c_transfer+0x86/0x90 [i2c_core]
[   20.155764]  [<e80a5586>] ? i2c_transfer+0x86/0x90 [i2c_core]
[   20.155899]  [<e80a5586>] i2c_transfer+0x86/0x90 [i2c_core]
[   20.155998]  [<e808f184>] dibx000_i2c_gated_tuner_xfer+0x134/0x1e0 [dibx000_common]
[   20.156112]  [<c0380002>] ? ieee80211_if_read_dropped_frames_ttl+0x12/0x30
[   20.156250]  [<c038e6d9>] ? mutex_lock_nested+0x1d9/0x270
[   20.156388]  [<e80a555c>] i2c_transfer+0x5c/0x90 [i2c_core]
[   20.156488]  [<e812c0da>] dib0070_read_reg+0x4a/0x70 [dib0070]
[   20.156592]  [<c0380002>] ? ieee80211_if_read_dropped_frames_ttl+0x12/0x30
[   20.156697]  [<c012e7c5>] ? msleep+0x15/0x30
[   20.156697]  [<e812cdf4>] dib0070_attach+0x84/0x3f4 [dib0070]
[   20.156697]  [<c038eb88>] ? mutex_unlock+0x8/0x10
[   20.156697]  [<e818cf37>] dib7070p_tuner_attach+0x37/0x80 [dvb_usb_dib0700]
[   20.156697]  [<e815ae9d>] dvb_usb_adapter_frontend_init+0x7d/0x100 [dvb_usb]
[   20.156697]  [<e815a850>] dvb_usb_device_init+0x390/0x5c0 [dvb_usb]
[   20.156697]  [<e818c30c>] dib0700_probe+0x4c/0x80 [dvb_usb_dib0700]
[   20.156697]  [<e80757f8>] usb_probe_interface+0xa8/0x150 [usbcore]
[   20.156697]  [<c01cea92>] ? sysfs_create_link+0x12/0x20
[   20.156697]  [<c0295f67>] driver_probe_device+0x87/0x1b0
[   20.156697]  [<c0296109>] __driver_attach+0x79/0x80
[   20.156697]  [<c029581b>] bus_for_each_dev+0x5b/0x80
[   20.156697]  [<c0295dc9>] driver_attach+0x19/0x20
[   20.156697]  [<c0296090>] ? __driver_attach+0x0/0x80
[   20.156697]  [<c02951af>] bus_add_driver+0x1cf/0x250
[   20.156697]  [<c02962bc>] driver_register+0x6c/0x150
[   20.156697]  [<e8075ae7>] usb_register_driver+0x87/0x100 [usbcore]
[   20.156697]  [<e8108000>] ? dib0700_module_init+0x0/0x50 [dvb_usb_dib0700]
[   20.156697]  [<e8108000>] ? dib0700_module_init+0x0/0x50 [dvb_usb_dib0700]
[   20.156697]  [<e8108030>] dib0700_module_init+0x30/0x50 [dvb_usb_dib0700]
[   20.156697]  [<c010111a>] do_one_initcall+0x2a/0x150
[   20.156697]  [<c0145a9b>] ? trace_hardirqs_off+0xb/0x10
[   20.156697]  [<c038fcbf>] ? _spin_unlock_irqrestore+0x4f/0x60
[   20.156697]  [<c01472eb>] ? trace_hardirqs_on+0xb/0x10
[   20.156697]  [<c014729d>] ? trace_hardirqs_on_caller+0xfd/0x140
[   20.156697]  [<c015145a>] sys_init_module+0x8a/0x1b0
[   20.156697]  [<c014729d>] ? trace_hardirqs_on_caller+0xfd/0x140
[   20.156697]  [<c0233978>] ? trace_hardirqs_on_thunk+0xc/0x10
[   20.156697]  [<c0103c3d>] sysenter_do_call+0x12/0x35
[   20.156697]  =======================
[   20.319556] DiB0070: successfully identified
[   20.319940] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:08.2/usb1/1-3/1-3.1/input/input6

[   20.348675] dvb-usb: schedule remote query interval to 150 msecs.
[   20.348762] dvb-usb: Hauppauge Nova-T Stick successfully initialized and connected.
[   20.349293] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[   20.349504] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   20.350101] DVB: registering new adapter (Hauppauge Nova-T Stick)
[   20.565856] DVB: registering frontend 1 (DiBcom 7000PC)...
[   20.747239] DiB0070: successfully identified
[   20.747614] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:08.2/usb1/1-3/1-3.2/input/input7
[   20.770369] dvb-usb: schedule remote query interval to 150 msecs.
[   20.770461] dvb-usb: Hauppauge Nova-T Stick successfully initialized and connected.
[   20.771017] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[   20.771232] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   20.771770] DVB: registering new adapter (Hauppauge Nova-T Stick)
[   21.020210] DVB: registering frontend 2 (DiBcom 7000PC)...
[   21.250041] DiB0070: successfully identified
[   21.250626] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:08.2/usb1/1-3/1-3.3/input/input8
[   21.277017] dvb-usb: schedule remote query interval to 150 msecs.
[   21.277106] dvb-usb: Hauppauge Nova-T Stick successfully initialized and connected.
[   21.277622] dvb-usb: found a 'Hauppauge Nova-T Stick' in warm state.
[   21.277862] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   21.278414] DVB: registering new adapter (Hauppauge Nova-T Stick)
[   21.631245] DVB: registering frontend 3 (DiBcom 7000PC)...
[   21.635351] MT2060: successfully identified (IF1 = 1220)
[   22.161297] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:08.2/usb1/1-3/1-3.4/input/input9
[   22.183759] dvb-usb: schedule remote query interval to 150 msecs.
[   22.183854] dvb-usb: Hauppauge Nova-T Stick successfully initialized and connected.
[   22.184316] usbcore: registered new interface driver dvb_usb_dib0700

I didn't notice any negative impact.
