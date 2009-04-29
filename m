Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZD2Hbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZD2Hbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZD2HbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:31:24 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:46124 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZD2HbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:31:23 -0400
Message-ID: <49F801F6.2020305@pook.es>
Date: Wed, 29 Apr 2009 09:29:58 +0200
From: Stuart Pook <linux-bluetooth4@pook.es>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: bluetoothd 4.37 -> Segmentation fault
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I'm getting Segmentation faults with bluez 4.37 and linux 2.6.30-rc2.

My VoIP client twinkle gets errors as well

:; twinkle 
ALSA lib pcm_bluetooth.c:1607:(audioservice_expect) BT_START_STREAM failed : Success(0)
ALSA lib pcm_bluetooth.c:1566:(audioservice_recv) Too short (1 bytes) IPC packet from bluetoothd
KCrash: Application 'twinkle' crashing...


:; twinkle 
ALSA lib pcm_bluetooth.c:1566:(audioservice_recv) Too short (0 bytes) IPC packet from bluetoothd
ALSA lib pcm_bluetooth.c:1607:(audioservice_expect) BT_START_STREAM failed : Success(0)
ALSA lib pcm_bluetooth.c:1566:(audioservice_recv) Too short (1 bytes) IPC packet from bluetoothd


: root; valgrind /usr/local/sbin/bluetoothd -dn
==6697== Memcheck, a memory error detector.
==6697== Copyright (C) 2002-2008, and GNU GPL'd, by Julian Seward et al.
==6697== Using LibVEX rev 1884, a library for dynamic binary translation.
==6697== Copyright (C) 2004-2008, and GNU GPL'd, by OpenWorks LLP.
==6697== Using valgrind-3.4.1-Debian, a dynamic binary instrumentation framework.
==6697== Copyright (C) 2000-2008, and GNU GPL'd, by Julian Seward et al.
==6697== For more details, rerun with: -v
==6697== 
bluetoothd[6697]: Bluetooth daemon 4.37
bluetoothd[6697]: Enabling debug information
bluetoothd[6697]: parsing main.conf
bluetoothd[6697]: discovto=0
bluetoothd[6697]: Key file does not have key 'PairableTimeout'
bluetoothd[6697]: pageto=8192
bluetoothd[6697]: name=%h-%d
bluetoothd[6697]: class=0x000100
bluetoothd[6697]: inqmode=0
bluetoothd[6697]: Key file does not have key 'InitiallyPowered'
bluetoothd[6697]: Key file does not have key 'RememberPowered'
bluetoothd[6697]: Key file does not have key 'DeviceID'
bluetoothd[6697]: Key file does not have key 'ReverseServiceDiscovery'
bluetoothd[6697]: Starting SDP server
bluetoothd[6697]: Loading plugins /usr/local/lib/bluetooth/plugins
bluetoothd[6697]: Parsing /etc/bluetooth/audio.conf failed: No such file or directory
bluetoothd[6697]: Unix socket created: 10
bluetoothd[6697]: Telephony plugin initialized
bluetoothd[6697]: HFP AG features: "Ability to reject a call" "Enhanced call status" "Extended Error Result Codes" 
bluetoothd[6697]: register_interface: path /org/bluez/6697/any
bluetoothd[6697]: Registered interface org.bluez.Service on path /org/bluez/6697/any
bluetoothd[6697]: HCI dev 0 registered
==6700== Syscall param ioctl(generic) points to unaddressable byte(s)
==6700==    at 0x40007F2: (within /lib/ld-2.9.so)
==6700==    by 0x112A5B: main (in /usr/local/stow/bluez-4.37/sbin/bluetoothd)
==6700==  Address 0x0 is not stack'd, malloc'd or (recently) free'd
bluetoothd[6697]: child 6700 forked
bluetoothd[6697]: Entering main loop
==6700== 
==6700== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 45 from 3)
==6700== malloc/free: in use at exit: 29,135 bytes in 329 blocks.
==6700== malloc/free: 638 allocs, 309 frees, 241,425 bytes allocated.
==6700== For counts of detected errors, rerun with: -v
==6700== searching for pointers to 329 not-freed blocks.
==6700== checked 114,748 bytes.
==6700== 
==6700== LEAK SUMMARY:
==6700==    definitely lost: 0 bytes in 0 blocks.
==6700==      possibly lost: 744 bytes in 3 blocks.
==6700==    still reachable: 28,391 bytes in 326 blocks.
==6700==         suppressed: 0 bytes in 0 blocks.
==6700== Rerun with --leak-check=full to see details of leaked memory.
bluetoothd[6697]: child 6700 exited
bluetoothd[6697]: HCI dev 0 up
bluetoothd[6697]: Starting security manager 0
bluetoothd[6697]: headset_server_probe: path /org/bluez/6697/hci0
bluetoothd[6697]: Adding record with handle 0x10000
bluetoothd[6697]: Record pattern UUID 00000003-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00000100-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00001002-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00001108-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00001112-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00001203-0000-1000-8000-00805f9
bluetoothd[6697]: Adding record with handle 0x10001
bluetoothd[6697]: Record pattern UUID 00000003-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00000100-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00001002-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 0000111e-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 0000111f-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00001203-0000-1000-8000-00805f9
bluetoothd[6697]: a2dp_server_probe: path /org/bluez/6697/hci0
bluetoothd[6697]: SEP 0x4b522f8 registered: type:0 codec:0 seid:1
bluetoothd[6697]: Adding record with handle 0x10002
bluetoothd[6697]: Record pattern UUID 00000019-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00000100-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00001002-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 0000110a-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 0000110d-0000-1000-8000-00805f9
bluetoothd[6697]: avrcp_server_probe: path /org/bluez/6697/hci0
bluetoothd[6697]: Adding record with handle 0x10003
bluetoothd[6697]: Record pattern UUID 00000017-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00000100-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00001002-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 0000110c-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 0000110e-0000-1000-8000-00805f9
bluetoothd[6697]: Adding record with handle 0x10004
bluetoothd[6697]: Record pattern UUID 00000017-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00000100-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 00001002-0000-1000-8000-00805f9
bluetoothd[6697]: Record pattern UUID 0000110e-0000-1000-8000-00805f9
bluetoothd[6697]: register_interface: path /org/bluez/6697/hci0
bluetoothd[6697]: Registered interface org.bluez.Service on path /org/bluez/6697/hci0
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98
bluetoothd[6697]: btd_device_ref(0x4b82c50): ref=1
bluetoothd[6697]: Probe drivers for /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98
bluetoothd[6697]: adapter_get_device(00:1A:45:2F:49:98)
bluetoothd[6697]: btd_device_ref(0x4b82c50): ref=2
bluetoothd[6697]: Registered interface org.bluez.Audio on path /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98
bluetoothd[6697]: Found Headset record
bluetoothd[6697]: Registered interface org.bluez.Headset on path /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98
bluetoothd[6697]: Found Handsfree record
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_14_A7_74_D3_AF
bluetoothd[6697]: btd_device_ref(0x4b9fe98): ref=1
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_03_89_B7_F8_D3
bluetoothd[6697]: btd_device_ref(0x4ba4d90): ref=1
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_0A_94_94_4F_B3
bluetoothd[6697]: btd_device_ref(0x4ba9c98): ref=1
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_03_89_DC_5C_9F
bluetoothd[6697]: btd_device_ref(0x4baeb58): ref=1
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_03_89_DC_FC_EC
bluetoothd[6697]: btd_device_ref(0x4bb3a68): ref=1
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_03_89_FE_E6_19
bluetoothd[6697]: btd_device_ref(0x4bb8928): ref=1
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_0E_6D_8F_91_6A
bluetoothd[6697]: btd_device_ref(0x4bbd7e8): ref=1
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_17_E5_E6_25_AB
bluetoothd[6697]: btd_device_ref(0x4bc26a8): ref=1
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_17_E5_16_88_6C
bluetoothd[6697]: btd_device_ref(0x4bc75d8): ref=1
bluetoothd[6697]: Creating device /org/bluez/6697/hci0/dev_00_17_E5_0C_EA_70
bluetoothd[6697]: btd_device_ref(0x4bcc498): ref=1
bluetoothd[6697]: Changing service classes to 0x480104
bluetoothd[6697]: Adapter /org/bluez/6697/hci0 has been enabled
bluetoothd[6697]: Computer is classified as desktop
bluetoothd[6697]: Current device class is 0x480104
bluetoothd[6697]: Setting 0x000104 for major/minor device class
bluetoothd[6697]: Changing major/minor class to 0x480104
bluetoothd[6697]: Agent registered for hci0 at :1.22:/org/bluez/agent/hci0
bluetoothd[6697]: Accepted new client connection on unix socket (fd=13)
bluetoothd[6697]: Audio API: BT_REQUEST <- BT_GET_CAPABILITIES
bluetoothd[6697]: Audio API: BT_RESPONSE -> BT_GET_CAPABILITIES
bluetoothd[6697]: Audio API: BT_REQUEST <- BT_OPEN
bluetoothd[6697]: open sco - object=ANY source=ANY destination=00:1A:45:2F:49:98 lock=write
bluetoothd[6697]: Audio API: BT_RESPONSE -> BT_OPEN
bluetoothd[6697]: Audio API: BT_REQUEST <- BT_SET_CONFIGURATION
bluetoothd[6697]: State changed /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98: HEADSET_STATE_DISCONNECTED -> HEADSET_STATE_CONNECT_IN_PROGRESS
bluetoothd[6697]: adapter_get_device(00:1A:45:2F:49:98)
bluetoothd[6697]: Discovered Handsfree service on RFCOMM channel 1
bluetoothd[6697]: /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98: Connecting to 00:1A:45:2F:49:98 channel 1
bluetoothd[6697]: link_key_request (sba=00:0C:41:E1:FF:30, dba=00:1A:45:2F:49:98)
bluetoothd[6697]: kernel auth requirements = 0x00
bluetoothd[6697]: stored link key type = 0x00
bluetoothd[6697]: Connection refused (111)
bluetoothd[6697]: Audio API: BT_RESPONSE -> BT_SET_CONFIGURATION
bluetoothd[6697]: telephony-dummy: device 0x4b93f20 disconnected
bluetoothd[6697]: State changed /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98: HEADSET_STATE_CONNECT_IN_PROGRESS -> HEADSET_STATE_DISCONNECTED
bluetoothd[6697]: Audio API: BT_REQUEST <- BT_START_STREAM
bluetoothd[6697]: State changed /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98: HEADSET_STATE_DISCONNECTED -> HEADSET_STATE_CONNECT_IN_PROGRESS
^Cbluetoothd[6697]: Removing adapter /org/bluez/6697/hci0
bluetoothd[6697]: headset_server_remove: path /org/bluez/6697/hci0
bluetoothd[6697]: Removing record with handle 0x10000
bluetoothd[6697]: Removing record with handle 0x10001
bluetoothd[6697]: a2dp_server_remove: path /org/bluez/6697/hci0
bluetoothd[6697]: Removing record with handle 0x10002
bluetoothd[6697]: avrcp_server_remove: path /org/bluez/6697/hci0
bluetoothd[6697]: Removing record with handle 0x10004
bluetoothd[6697]: Removing record with handle 0x10003
bluetoothd[6697]: unregister_interface: path /org/bluez/6697/hci0
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98
bluetoothd[6697]: Headset unregistered while device was connected!
bluetoothd[6697]: telephony-dummy: device 0x4b93f20 disconnected
bluetoothd[6697]: State changed /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98: HEADSET_STATE_CONNECT_IN_PROGRESS -> HEADSET_STATE_DISCONNECTED
bluetoothd[6697]: Unregistered interface org.bluez.Headset on path /org/bluez/6697/hci0/dev_00_1A_45_2F_49_98
bluetoothd[6697]: btd_device_unref(0x4b82c50): ref=1
bluetoothd[6697]: btd_device_unref(0x4b82c50): ref=0
bluetoothd[6697]: device_free(0x4b82c50)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_14_A7_74_D3_AF
bluetoothd[6697]: btd_device_unref(0x4b9fe98): ref=0
bluetoothd[6697]: device_free(0x4b9fe98)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_03_89_B7_F8_D3
bluetoothd[6697]: btd_device_unref(0x4ba4d90): ref=0
bluetoothd[6697]: device_free(0x4ba4d90)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_0A_94_94_4F_B3
bluetoothd[6697]: btd_device_unref(0x4ba9c98): ref=0
bluetoothd[6697]: device_free(0x4ba9c98)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_03_89_DC_5C_9F
bluetoothd[6697]: btd_device_unref(0x4baeb58): ref=0
bluetoothd[6697]: device_free(0x4baeb58)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_03_89_DC_FC_EC
bluetoothd[6697]: btd_device_unref(0x4bb3a68): ref=0
bluetoothd[6697]: device_free(0x4bb3a68)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_03_89_FE_E6_19
bluetoothd[6697]: btd_device_unref(0x4bb8928): ref=0
bluetoothd[6697]: device_free(0x4bb8928)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_0E_6D_8F_91_6A
bluetoothd[6697]: btd_device_unref(0x4bbd7e8): ref=0
bluetoothd[6697]: device_free(0x4bbd7e8)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_17_E5_E6_25_AB
bluetoothd[6697]: btd_device_unref(0x4bc26a8): ref=0
bluetoothd[6697]: device_free(0x4bc26a8)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_17_E5_16_88_6C
bluetoothd[6697]: btd_device_unref(0x4bc75d8): ref=0
bluetoothd[6697]: device_free(0x4bc75d8)
bluetoothd[6697]: Removing device /org/bluez/6697/hci0/dev_00_17_E5_0C_EA_70
bluetoothd[6697]: btd_device_unref(0x4bcc498): ref=0
bluetoothd[6697]: device_free(0x4bcc498)
==6697== Syscall param ioctl(generic) points to unaddressable byte(s)
==6697==    at 0x40007F2: (within /lib/ld-2.9.so)
==6697==    by 0x11C81A: manager_remove_adapter (in /usr/local/stow/bluez-4.37/sbin/bluetoothd)
==6697==    by 0x489EF06: g_slist_foreach (in /usr/lib/libglib-2.0.so.0.2000.1)
==6697==    by 0x11CC21: manager_cleanup (in /usr/local/stow/bluez-4.37/sbin/bluetoothd)
==6697==    by 0x126EC9: hcid_dbus_exit (in /usr/local/stow/bluez-4.37/sbin/bluetoothd)
==6697==    by 0x112ADD: main (in /usr/local/stow/bluez-4.37/sbin/bluetoothd)
==6697==  Address 0x0 is not stack'd, malloc'd or (recently) free'd
bluetoothd[6697]: Releasing agent :1.22, /org/bluez/agent/hci0
bluetoothd[6697]: Cleanup plugins
==6697== 
==6697== Invalid read of size 4
==6697==    at 0x4EE97E7: headset_cancel_stream (in /usr/local/stow/bluez-4.37/lib/bluetooth/plugins/audio.so)
==6697==    by 0x4EE222A: client_free (in /usr/local/stow/bluez-4.37/lib/bluetooth/plugins/audio.so)
==6697==    by 0x489EF06: g_slist_foreach (in /usr/lib/libglib-2.0.so.0.2000.1)
==6697==    by 0x4EE2161: unix_exit (in /usr/local/stow/bluez-4.37/lib/bluetooth/plugins/audio.so)
==6697==    by 0x4EE19B5: audio_exit (in /usr/local/stow/bluez-4.37/lib/bluetooth/plugins/audio.so)
==6697==    by 0x11807C: plugin_cleanup (in /usr/local/stow/bluez-4.37/sbin/bluetoothd)
==6697==    by 0x112AE4: main (in /usr/local/stow/bluez-4.37/sbin/bluetoothd)
==6697==  Address 0x1c is not stack'd, malloc'd or (recently) free'd
==6697== 
==6697== Process terminating with default action of signal 11 (SIGSEGV)
==6697==  Access not within mapped region at address 0x1C
==6697==    at 0x4EE97E7: headset_cancel_stream (in /usr/local/stow/bluez-4.37/lib/bluetooth/plugins/audio.so)
==6697==    by 0x4EE222A: client_free (in /usr/local/stow/bluez-4.37/lib/bluetooth/plugins/audio.so)
==6697==    by 0x489EF06: g_slist_foreach (in /usr/lib/libglib-2.0.so.0.2000.1)
==6697==    by 0x4EE2161: unix_exit (in /usr/local/stow/bluez-4.37/lib/bluetooth/plugins/audio.so)
==6697==    by 0x4EE19B5: audio_exit (in /usr/local/stow/bluez-4.37/lib/bluetooth/plugins/audio.so)
==6697==    by 0x11807C: plugin_cleanup (in /usr/local/stow/bluez-4.37/sbin/bluetoothd)
==6697==    by 0x112AE4: main (in /usr/local/stow/bluez-4.37/sbin/bluetoothd)
==6697==  If you believe this happened as a result of a stack overflow in your
==6697==  program's main thread (unlikely but possible), you can try to increase
==6697==  the size of the main thread stack using the --main-stacksize= flag.
==6697==  The main thread stack size used in this run was 8388608.
==6697== 
==6697== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 45 from 3)
==6697== malloc/free: in use at exit: 34,878 bytes in 375 blocks.
==6697== malloc/free: 3,098 allocs, 2,723 frees, 1,846,161 bytes allocated.
==6697== For counts of detected errors, rerun with: -v
==6697== searching for pointers to 375 not-freed blocks.
==6697== checked 115,248 bytes.
==6697== 
==6697== LEAK SUMMARY:
==6697==    definitely lost: 36 bytes in 2 blocks.
==6697==      possibly lost: 744 bytes in 3 blocks.
==6697==    still reachable: 34,098 bytes in 370 blocks.
==6697==         suppressed: 0 bytes in 0 blocks.
==6697== Rerun with --leak-check=full to see details of leaked memory.
Segmentation fault

-- 
If the From address bounces, please see http://www.pook.it/.
