Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZGXO5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZGXO5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 10:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbZGXO5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 10:57:41 -0400
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:35579 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751530AbZGXO5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 10:57:40 -0400
X-Greylist: delayed 1579 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jul 2009 10:57:39 EDT
Message-ID: <4A69C5B5.7020906@ph.tum.de>
Date: Fri, 24 Jul 2009 16:31:17 +0200
From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.31-rc3: circular locking: option_resume / usb_extern,al_resume_device
Content-Type: multipart/mixed;
 boundary="------------080206070702070308070202"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080206070702070308070202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The following happened on a suspend-resume cycle with
2.6.31-rc3 on an Eee PC 1000HGO.  So far I've only observed it once.
Kernel config and bootup dmesg output is attached.

If somebody is interested in further info, just ask...

Kind regards,

Thiemo

[ 3333.197562] usb 5-6: unlink qh2-0001/f615e180 start 1 [2/0 us]
[ 3333.197647] option: option_instat_callback: error -2
[ 3333.198657] usb 5-6: usb suspend
[ 3335.001286] hub 5-0:1.0: hub_suspend
[ 3335.001362] usb usb5: bus auto-suspend
[ 3335.001386] ehci_hcd 0000:00:1d.7: suspend root hub
[ 3343.473220] usb usb5: usb auto-resume
[ 3343.473263] ehci_hcd 0000:00:1d.7: resume root hub
[ 3343.494209] hub 5-0:1.0: hub_resume
[ 3343.497470] hub 5-0:1.0: port 6: status 0507 change 0000
[ 3343.498583] hub 5-0:1.0: port 8: status 0501 change 0000
[ 3343.498897] hub 5-0:1.0: state 7 ports 8 chg 0100 evt fe00
[ 3343.501620] hub 5-0:1.0: port 8, status 0501, change 0000, 480 Mb/s
[ 3343.506794] usb 5-6: usb resume
[ 3343.533463] ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001005
POWER sig=se0 PE CONNECT
[ 3343.548165] usb 5-6: finish resume
[ 3343.550850] ehci_hcd 0000:00:1d.7: reused qh f615e180 schedule
[ 3343.550893] usb 5-6: link qh2-0001/f615e180 start 1 [2/0 us]
[ 3343.550980]
[ 3343.550987] =======================================================
[ 3343.551017] [ INFO: possible circular locking dependency detected ]
[ 3343.551045] 2.6.31-rc3 #3
[ 3343.551064] -------------------------------------------------------
[ 3343.551090] sh/25228 is trying to acquire lock:
[ 3343.551113]  (&port->mutex){+.+...}, at: [<f8274322>]
option_resume+0xd9/0x16f [option]
[ 3343.551214]
[ 3343.551221] but task is already holding lock:
[ 3343.551245]  (&dev->pm_mutex/1){+.+.+.}, at: [<c11c313e>]
usb_external_resume_device+0x1e/0x60
[ 3343.551321]
[ 3343.551328] which lock already depends on the new lock.
[ 3343.551338]
[ 3343.551360]
[ 3343.551366] the existing dependency chain (in reverse order) is:
[ 3343.551392]
[ 3343.551399] -> #2 (&dev->pm_mutex/1){+.+.+.}:
[ 3343.551459]        [<c104fdac>] __lock_acquire+0x99d/0xb0c
[ 3343.551508]        [<c104ffc3>] lock_acquire+0xa8/0xc5
[ 3343.551550]        [<c126acb0>] __mutex_lock_common+0x3e/0x390
[ 3343.551575]        [<c126b08b>] mutex_lock_nested+0x29/0x31
[ 3343.551575]        [<c11c2a9c>] usb_autopm_do_interface+0x2d/0xbf
[ 3343.551575]        [<c11c2b47>] usb_autopm_get_interface+0xd/0xf
[ 3343.551575]        [<f82c3e4e>] serial_open+0x11b/0x1b9 [usbserial]
[ 3343.551575]        [<c1190662>] tty_open+0x290/0x38e
[ 3343.551575]        [<c10b0865>] chrdev_open+0x11a/0x131
[ 3343.551575]        [<c10ac956>] __dentry_open+0x156/0x24b
[ 3343.551575]        [<c10acae5>] nameidata_to_filp+0x2c/0x43
[ 3343.551575]        [<c10b716c>] do_filp_open+0x3ef/0x75a
[ 3343.551575]        [<c10ac709>] do_sys_open+0x4a/0xe2
[ 3343.551575]        [<c10ac7e3>] sys_open+0x1e/0x26
[ 3343.551575]        [<c1002f04>] sysenter_do_call+0x12/0x32
[ 3343.551575]        [<ffffffff>] 0xffffffff
[ 3343.551575]
[ 3343.551575] -> #1 (&serial->disc_mutex){+.+...}:
[ 3343.551575]        [<c104fdac>] __lock_acquire+0x99d/0xb0c
[ 3343.551575]        [<c104ffc3>] lock_acquire+0xa8/0xc5
[ 3343.551575]        [<c126acb0>] __mutex_lock_common+0x3e/0x390
[ 3343.551575]        [<c126b08b>] mutex_lock_nested+0x29/0x31
[ 3343.551575]        [<f82c3e40>] serial_open+0x10d/0x1b9 [usbserial]
[ 3343.551575]        [<c1190662>] tty_open+0x290/0x38e
[ 3343.551575]        [<c10b0865>] chrdev_open+0x11a/0x131
[ 3343.551575]        [<c10ac956>] __dentry_open+0x156/0x24b
[ 3343.551575]        [<c10acae5>] nameidata_to_filp+0x2c/0x43
[ 3343.551575]        [<c10b716c>] do_filp_open+0x3ef/0x75a
[ 3343.551575]        [<c10ac709>] do_sys_open+0x4a/0xe2
[ 3343.551575]        [<c10ac7e3>] sys_open+0x1e/0x26
[ 3343.551575]        [<c1002f04>] sysenter_do_call+0x12/0x32
[ 3343.551575]        [<ffffffff>] 0xffffffff
[ 3343.551575]
[ 3343.551575] -> #0 (&port->mutex){+.+...}:
[ 3343.551575]        [<c104fcbe>] __lock_acquire+0x8af/0xb0c
[ 3343.551575]        [<c104ffc3>] lock_acquire+0xa8/0xc5
[ 3343.551575]        [<c126acb0>] __mutex_lock_common+0x3e/0x390
[ 3343.551575]        [<c126b08b>] mutex_lock_nested+0x29/0x31
[ 3343.551575]        [<f8274322>] option_resume+0xd9/0x16f [option]
[ 3343.551575]        [<f82c282c>] usb_serial_resume+0x1e/0x29 [usbserial]
[ 3343.551575]        [<c11c23b2>] usb_resume_interface+0xbf/0x12a
[ 3343.551575]        [<c11c2813>] usb_resume_both+0xe6/0x108
[ 3343.551575]        [<c11c314e>] usb_external_resume_device+0x2e/0x60
[ 3343.551575]        [<c11c5aa9>] set_level+0xba/0x140
[ 3343.551575]        [<c11a78af>] dev_attr_store+0x1b/0x23
[ 3343.551575]        [<c10f099a>] sysfs_write_file+0xb9/0xe4
[ 3343.551575]        [<c10ae820>] vfs_write+0x84/0xdf
[ 3343.551575]        [<c10ae914>] sys_write+0x3b/0x60
[ 3343.551575]        [<c1002f04>] sysenter_do_call+0x12/0x32
[ 3343.551575]        [<ffffffff>] 0xffffffff
[ 3343.551575]
[ 3343.551575] other info that might help us debug this:
[ 3343.551575]
[ 3343.551575] 2 locks held by sh/25228:
[ 3343.551575]  #0:  (&buffer->mutex){+.+.+.}, at: [<c10f0906>]
sysfs_write_file+0x25/0xe4
[ 3343.551575]  #1:  (&dev->pm_mutex/1){+.+.+.}, at: [<c11c313e>]
usb_external_resume_device+0x1e/0x60
[ 3343.551575]
[ 3343.551575] stack backtrace:
[ 3343.551575] Pid: 25228, comm: sh Not tainted 2.6.31-rc3 #3
[ 3343.551575] Call Trace:
[ 3343.551575]  [<c1269a57>] ? printk+0xf/0x18
[ 3343.551575]  [<c104f14b>] print_circular_bug_tail+0x5d/0x68
[ 3343.551575]  [<c104fcbe>] __lock_acquire+0x8af/0xb0c
[ 3343.551575]  [<c104ffc3>] lock_acquire+0xa8/0xc5
[ 3343.551575]  [<f8274322>] ? option_resume+0xd9/0x16f [option]
[ 3343.551575]  [<c126acb0>] __mutex_lock_common+0x3e/0x390
[ 3343.551575]  [<f8274322>] ? option_resume+0xd9/0x16f [option]
[ 3343.551575]  [<c126b08b>] mutex_lock_nested+0x29/0x31
[ 3343.551575]  [<f8274322>] ? option_resume+0xd9/0x16f [option]
[ 3343.551575]  [<f8274322>] option_resume+0xd9/0x16f [option]
[ 3343.551575]  [<f82c282c>] usb_serial_resume+0x1e/0x29 [usbserial]
[ 3343.551575]  [<c11c23b2>] usb_resume_interface+0xbf/0x12a
[ 3343.551575]  [<c11c2813>] usb_resume_both+0xe6/0x108
[ 3343.551575]  [<c11c314e>] usb_external_resume_device+0x2e/0x60
[ 3343.551575]  [<c11c5aa9>] set_level+0xba/0x140
[ 3343.551575]  [<c11c59ef>] ? set_level+0x0/0x140
[ 3343.551575]  [<c11a78af>] dev_attr_store+0x1b/0x23
[ 3343.551575]  [<c10f099a>] sysfs_write_file+0xb9/0xe4
[ 3343.551575]  [<c10f08e1>] ? sysfs_write_file+0x0/0xe4
[ 3343.551575]  [<c10ae820>] vfs_write+0x84/0xdf
[ 3343.551575]  [<c10ae914>] sys_write+0x3b/0x60
[ 3343.551575]  [<c1002f04>] sysenter_do_call+0x12/0x32

-- 
+-----------------------------------+--------------------------+
| Dipl.-Phys. Thiemo Nagel          |                          |
| Technische Universitaet Muenchen  | Room    PH1 3276         |
| Physik-Department E18             |                          |
| James-Franck-Strasse              | Phone  +49 89 289-12379  |
| D-85747 Garching                  | Fax    +49 89 289-12570  |
+-----------------------------------+--------------------------+


--------------080206070702070308070202
Content-Type: application/x-bzip;
 name="config-2.6.31-rc3.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config-2.6.31-rc3.bz2"

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
--------------080206070702070308070202
Content-Type: application/x-bzip;
 name="full-dmesg.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="full-dmesg.bz2"

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
cKEhx2efjA==
--------------080206070702070308070202--
