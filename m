Return-Path: <linux-kernel-owner+w=401wt.eu-S1759597AbYBSV2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597AbYBSV2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753554AbYBSV2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:28:31 -0500
Received: from server1.nasreddine.com ([82.225.70.234]:57305 "EHLO
	server1.nasreddine.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbYBSV22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:28:28 -0500
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2008 16:28:27 EST
Date: Tue, 19 Feb 2008 22:19:59 +0100
From: Wael Nasreddine <mla@nasreddine.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>, "Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: iwl3945 not working properly.
Message-ID: <20080219211959.GA6623@phoenix.nasreddine.info>
References: <20080218045425.GA7381@phoenix.nasreddine.info> <20080218154713.GC3098@tuxdriver.com> <D936D925018D154694D8A362EEB0892003AF2CA1@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <D936D925018D154694D8A362EEB0892003AF2CA1@orsmsx416.amr.corp.intel.com>
X-OS: Linux 2.6.24-tuxonice-r2 i686
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled Feb  4 2008 15:13:47)
X-PGP-Key: http://wael.nasreddine.com/files/Wael_Nasreddine.asc
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This One Time, at Band Camp, "Chatre, Reinette" <reinette.chatre@intel.com>=
 said, On Tue, Feb 19, 2008 at 10:00:40AM -0800:
> On Monday, February 18, 2008 7:47 AM, John W. Linville  wrote:

> > On Mon, Feb 18, 2008 at 05:54:25AM +0100, Wael Nasreddine wrote:
> >> Hello,

> >> I have a Toshiba Satellite A135-S4427 with and Intel 3945ABG card,
> >> the driver is not working properly.

> >> When I turn on my PC it works fine, but If I ever bring the interface
> >> down, I no longer can associate it with any AP without rebooting,
> >> even the one I was using, I tried rmmod/modprobe iwl3945, didn't do
> >> anything,=20

> >> iwconfig shows that the wlan0 has the radio turned off, and

> >> $ cat /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill 1

> >> Even If I echo 0 > /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
> >> whenever I try to associate the interface with an AP it turns back to
> >> 1, I tried both iwconfig and NetworkManager, same problem.

> >> There's a button on my laptop for Radio SoftKill (fn+F8) but it's not
> >> working, the soft kill is being enabled/disabled without my
> >> interference.=20

> >> I tried it on kernel-2.6.24 and kernel-2.6.25-rc2 same result...

> >> Any help is appreciated...

> >> P.S: Please Cc to me, I am not subscribed to the mailing list.

> > This sounds similar to the bug here:

> > 	https://bugzilla.redhat.com/show_bug.cgi?id=3D432264

> > The OP in that bug reports that the problem continues even after
> > reverting to older kernels that worked previously.

> > Hopefully part of the Intel crew will have some clue as to what is
> > happending here?=20

> Wael,

> Could you please help us debug this issue? Unfortunately none of the
> bugs reported about this issue
> (http://bughost.org/bugzilla/show_bug.cgi?id=3D1454 and
> https://bugzilla.redhat.com/show_bug.cgi?id=3D432264) have any debugging
> output. Please reopen bug
> http://bughost.org/bugzilla/show_bug.cgi?id=3D1454 and add debugging
> (loading module with debug=3D0x43fff) to your report to help us find out
> what happens on your system when the driver loads as well as when you
> change the rfkill settings.

> Thank you very much

> Reinette

Reinette,

Since the problem I am having is slightly different than the bugs
above, I'm not sure I should post the debug there but feel free to
post it if you think it is the same...

Anyway, here attached is the debugging file, I hope this helps,
because it's so annoying, I had to reboot my laptop is order to send
this message...

Regards,

--=20
Wael Nasreddine
http://wael.nasreddine.com
PGP: 1024D/C8DD18A2 06F6 1622 4BC8 4CEB D724  DE12 5565 3945 C8DD 18A2

=2E: An infinite number of monkeys typing into GNU emacs,
   would never make a good program. (L. Torvalds 1995) :.

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwl3945.debug"
Content-Transfer-Encoding: quoted-printable

$ rmmod iwl3945
$ modprobe iwl3945 debug=3D3D0x43fff
$ dmesg
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Lin=
ux, 1.1.17kds
iwl3945: Copyright(c) 2003-2007 Intel Corporation
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
iwl3945: U iwl_pci_probe pci_resource_len =3D 0x00001000
iwl3945: U iwl_pci_probe pci_resource_base =3D f9990000
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
iwl3945: U iwl_set_rxon_channel Staging channel set to 6 [2]
iwl3945: U iwl_read_ucode Got firmware 'iwlwifi-3945-1.ucode' file (149652 =
bytes) from disk
iwl3945: U iwl_read_ucode f/w package hdr ucode version =3D 0x20e0105
iwl3945: U iwl_read_ucode f/w package hdr runtime inst size =3D 80524
iwl3945: U iwl_read_ucode f/w package hdr runtime data size =3D 32768
iwl3945: U iwl_read_ucode f/w package hdr init inst size =3D 2668
iwl3945: U iwl_read_ucode f/w package hdr init data size =3D 32768
iwl3945: U iwl_read_ucode f/w package hdr boot inst size =3D 900
iwl3945: U iwl_read_ucode Copying (but not loading) uCode instr len 80524
iwl3945: U iwl_read_ucode uCode instr buf vaddr =3D 0xdff80000, paddr =3D 0=
x1ff80000
iwl3945: U iwl_read_ucode Copying (but not loading) uCode data len 32768
iwl3945: U iwl_read_ucode Copying (but not loading) init instr len 2668
iwl3945: U iwl_read_ucode Copying (but not loading) init data len 32768
iwl3945: U iwl_read_ucode Copying (but not loading) boot instr len 900
iwl3945: U iwl_pci_probe Queing UP work.
iwl3945: U iwl_hw_nic_init HW Revision ID =3D 0x2
iwl3945: U iwl_hw_nic_init ALM-MM type
iwl3945: U iwl_hw_nic_init SKU OP mode is basic
iwl3945: U iwl_hw_nic_init 3945ABG revision is 0xF1
iwl3945: U iwl_hw_nic_init Card M type B version is 0x2
iwl3945: U iwl_load_bsm Begin load bsm
iwl3945: U iwl_verify_bsm Begin verify bsm
iwl3945: U iwl_verify_bsm BSM bootstrap uCode image OK
iwl3945: U iwl_load_bsm BSM write complete, poll 1 iterations
iwl3945: U __iwl_up MAC address: 00:19:d2:42:91:3f
iwl3945: U __iwl_up iwl3945 is coming up
iwl3945: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
iwl3945: I iwl_rx_reply_alive Initialization Alive received.
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 900
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 2668
iwl3945: U iwl_verify_ucode Initialize uCode is good in inst SRAM
iwl3945: U iwl_init_alive_start Initialization Alive received.
iwl3945: U iwl_set_ucode_ptrs Runtime uCode pointers are set.
iwl3945: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
iwl3945: I iwl_rx_reply_alive Runtime Alive received.
iwl3945: I iwl_disable_events Selected uCode log events may be disabled
iwl3945: I iwl_disable_events   by writing "1"s into disable bitmap
iwl3945: I iwl_disable_events   in SRAM at 0x8015f4, size 47 u32s
iwl3945: U iwl_alive_start Runtime Alive received.
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 900
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 2668
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 80524
iwl3945: U iwl_verify_ucode Runtime uCode is good in inst SRAM
iwl3945: U iwl_alive_start RFKILL status: 0x1
iwl3945: U iwl_init_channel_map Initializing regulatory info from EEPROM
iwl3945: U iwl_init_channel_map Parsing data for 56 channels.
iwl3945: U iwl_init_channel_map Ch. 1 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dBm=
): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 2 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dBm=
): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 3 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dBm=
): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 4 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dBm=
): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 5 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dBm=
): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 6 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dBm=
): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 7 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dBm=
): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 8 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dBm=
): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 9 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dBm=
): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 10 [2.4GHz] IBSS ACTIVE WIDE (0x2b 15dB=
m): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 11 [2.4GHz] IBSS ACTIVE WIDE (0x2b 14dB=
m): Ad-Hoc supported
iwl3945: U iwl_init_channel_map Ch. 12 Flags 0 [2.4GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 13 Flags 0 [2.4GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 14 Flags 0 [2.4GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 183 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 184 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 185 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 187 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 188 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 189 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 192 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 196 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 7 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 8 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 11 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 12 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 16 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 34 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 36 [5.2GHz] WIDE DFS (0xa1 14dBm): Ad-H=
oc not supported
iwl3945: U iwl_init_channel_map Ch. 38 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 40 [5.2GHz] WIDE DFS (0xa1 14dBm): Ad-H=
oc not supported
iwl3945: U iwl_init_channel_map Ch. 42 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 44 [5.2GHz] WIDE DFS (0xa1 14dBm): Ad-H=
oc not supported
iwl3945: U iwl_init_channel_map Ch. 46 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 48 [5.2GHz] WIDE DFS (0xa1 14dBm): Ad-H=
oc not supported
iwl3945: U iwl_init_channel_map Ch. 52 [5.2GHz] RADAR WIDE DFS (0xb1 14dBm)=
: Ad-Hoc not supported
iwl3945: U iwl_init_channel_map Ch. 56 [5.2GHz] RADAR WIDE DFS (0xb1 14dBm)=
: Ad-Hoc not supported
iwl3945: U iwl_init_channel_map Ch. 60 [5.2GHz] RADAR WIDE DFS (0xb1 14dBm)=
: Ad-Hoc not supported
iwl3945: U iwl_init_channel_map Ch. 64 [5.2GHz] RADAR WIDE DFS (0xb1 14dBm)=
: Ad-Hoc not supported
iwl3945: U iwl_init_channel_map Ch. 100 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 104 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 108 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 112 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 116 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 120 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 124 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 128 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 132 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 136 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 140 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 145 Flags 0 [5.2GHz] - No traffic
iwl3945: U iwl_init_channel_map Ch. 149 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc =
not supported
iwl3945: U iwl_init_channel_map Ch. 153 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc =
not supported
iwl3945: U iwl_init_channel_map Ch. 157 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc =
not supported
iwl3945: U iwl_init_channel_map Ch. 161 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc =
not supported
iwl3945: U iwl_init_channel_map Ch. 165 [5.2GHz] WIDE (0x21 16dBm): Ad-Hoc =
not supported
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 81
iwl3945: U iwl_init_geos Channel 12 [2.4GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 13 [2.4GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 14 [2.4GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 183 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 184 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 185 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 187 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 188 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 189 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 192 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 196 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 7 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 8 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 11 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 12 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 16 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 34 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 38 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 42 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 46 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 100 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 104 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 108 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 112 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 116 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 120 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 124 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 128 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 132 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 136 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 140 [5.2GHz] is restricted -- skipping.
iwl3945: U iwl_init_geos Channel 145 [5.2GHz] is restricted -- skipping.
iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
phy2: Selected rate control algorithm 'iwl-3945-rs'
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 114
iwl3945: U iwl_alive_start ALIVE processing complete.
iwl3945: U iwl_mac_start enter
iwl3945: U iwl_mac_start leave
iwl3945: U iwl_mac_add_interface enter: id 10, type 2
iwl3945: U iwl_mac_add_interface Set: 00:19:d2:42:91:3f
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_add_interface leave
iwl3945: U iwl_mac_config_interface enter: interface id 10
iwl3945: U iwl_mac_config_interface bssid: 00:00:00:00:00:00
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_config_interface leave
ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 4
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 5
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 7
iwl3945: U iwl_mac_hw_scan enter
iwl3945: U iwl_scan_initiate Starting scan...
iwl3945: U iwl_mac_hw_scan leave
iwl3945: I iwl_rx_scan_complete_notif Scan pass on 2.4GHz took 111ms
iwl3945: I iwl_rx_scan_complete_notif Scan pass on 5.2GHz took 1478ms
iwl3945: I iwl_rx_scan_complete_notif Setting scan to off
iwl3945: I iwl_rx_scan_complete_notif Scan took 1589ms
iwl3945: U iwl_bg_scan_completed SCAN complete scan
iwl3945: U iwl_mac_config enter to channel 1
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_config leave
iwl3945: U iwl_mac_config enter to channel 11
iwl3945: U iwl_set_rxon_channel Staging channel set to 11 [2]
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:00:00:00:00:00
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_config leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 4
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 5
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 7
iwl3945: U iwl_mac_config_interface enter: interface id 10
iwl3945: U iwl_mac_config_interface bssid: 00:06:25:9b:85:e0
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:06:25:9b:85:e0
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_config_interface leave
iwl3945: U iwl_mac_reset_tsf enter
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:06:25:9b:85:e0
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:06:25:9b:85:e0
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
wlan0: RX authentication from 00:06:25:9b:85:e0 (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:06:25:9b:85:e0
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
wlan0: RX AssocResp from 00:06:25:9b:85:e0 (capab=3D0x1 status=3D0 aid=3D2)
wlan0: associated
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
iwl3945: U iwl_bg_post_associate Associated as 2 to: 00:06:25:9b:85:e0
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:06:25:9b:85:e0
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_setup_rxon_timing beacon interval 100 beacon timer 62139 bea=
con tim 0
iwl3945: U iwl_bg_post_associate assoc id 2 beacon interval 100
iwl3945: U iwl_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:06:25:9b:85:e0
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_add_station Add STA ID 0: 00:06:25:9b:85:e0
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_rate_scale_init Network RSSI: -54
iwl3945: U iwl_mac_hw_scan enter
iwl3945: U iwl_mac_hw_scan enter
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
iwl3945: U iwl_mac_set_key enter
iwl3945: U iwl_mac_set_key leave - hwcrypto disabled
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 4
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 5
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 7
iwl3945: U iwl_mac_config enter to channel 11
iwl3945: U iwl_mac_config No re-sending same RXON configuration.
iwl3945: U iwl_mac_config leave
iwl3945: U iwl_mac_config enter to channel 11
iwl3945: U iwl_mac_config No re-sending same RXON configuration.
iwl3945: U iwl_mac_config leave
iwl3945: U iwl_mac_config_interface enter: interface id 10
iwl3945: U iwl_mac_config_interface bssid: 00:13:10:1a:07:77
iwl3945: U iwl_commit_rxon Toggling associated bit on current RXON
iwl3945: U iwl_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_add_station Add STA ID 0: 00:13:10:1a:07:77
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_config_interface leave
iwl3945: U iwl_mac_reset_tsf enter
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:13:10:1a:07:77
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
iwl3945: U iwl_mac_reset_tsf enter
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:13:10:1a:07:77
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
wlan0: RX authentication from 00:13:10:1a:07:77 (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:13:10:1a:07:77
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
wlan0: authentication frame received from 00:13:10:1a:07:77, but not in aut=
henticate state - ignored
iwl3945: U iwl_bg_post_associate Associated as 1 to: 00:13:10:1a:07:77
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
wlan0: RX AssocResp from 00:13:10:1a:07:77 (capab=3D0x411 status=3D0 aid=3D=
1)
wlan0: associated
wlan0: No ProbeResp from current AP 00:13:10:1a:07:77 - assume out of range
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_setup_rxon_timing beacon interval 100 beacon timer 102004 be=
acon tim 0
iwl3945: U iwl_bg_post_associate assoc id 1 beacon interval 100
iwl3945: U iwl_commit_rxon Sending RXON
* with RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_add_station Add STA ID 0: 00:13:10:1a:07:77
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
wlan0: no IPv6 routers present
iwl3945: U iwl_mac_config_interface enter: interface id 10
iwl3945: U iwl_mac_config_interface bssid: 00:00:00:00:00:00
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_config_interface leave
iwl3945: U iwl_mac_config enter to channel 11
iwl3945: U iwl_mac_config No re-sending same RXON configuration.
iwl3945: U iwl_mac_config leave
iwl3945: U iwl_mac_config_interface enter: interface id 10
iwl3945: U iwl_mac_config_interface bssid: 00:13:10:1a:07:77
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_config_interface leave
iwl3945: U iwl_mac_reset_tsf enter
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:13:10:1a:07:77
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
wlan0: RX authentication from 00:13:10:1a:07:77 (alg=3D0 transaction=3D2 st=
atus=3D0)
wlan0: authenticated
wlan0: associate with AP 00:13:10:1a:07:77
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
wlan0: RX ReassocResp from 00:13:10:1a:07:77 (capab=3D0x411 status=3D0 aid=
=3D1)
wlan0: associated
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 4
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 5
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 7
iwl3945: U iwl_mac_config enter to channel 11
iwl3945: U iwl_mac_config No re-sending same RXON configuration.
iwl3945: U iwl_mac_config leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 4
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 5
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 7
iwl3945: U iwl_mac_reset_tsf enter
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_reset_tsf leave - not in IBSS
wlan0: Initial auth_alg=3D0
wlan0: authenticate with AP 00:13:10:1a:07:77
iwl3945: I iwl_mac_tx enter
iwl3945: I iwl_mac_tx leave
iwl3945: U iwl_mac_config enter to channel 11
iwl3945: U iwl_mac_config leave - radio disabled
iwl3945: U iwl_mac_remove_interface enter
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: U iwl_mac_remove_interface leave
iwl3945: U iwl_mac_stop enter
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 11
* bssid =3D 00:13:10:1a:07:77
iwl3945: Error sending REPLY_RXON: time out after 500ms.
iwl3945: Error setting new configuration (-110).
iwl3945: U iwl_mac_stop leave
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 135
iwl3945: Error sending REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 135
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 135
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 135

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

$ iwconfig
wlan0     IEEE 802.11g  ESSID:"eMxyzptlk" =20
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:13:10:1A:07:7=
7  =20
          Bit Rate=3D54 Mb/s   Tx-Power=3Doff  =20
          Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B  =20
          Link Quality=3D92/100  Signal level=3D-39 dBm  Noise level=3D-63 =
dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

$ cat /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
1

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

$ echo 0 > /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
$ dmesg
iwl3945: U __iwl_down iwl3945 is going down
iwl3945: U iwl_hw_nic_stop_master stop master
iwl3945: U iwl_clear_free_frames 0 frames on pre-allocated heap on clear.
iwl3945: U iwl_hw_nic_init HW Revision ID =3D 0x2
iwl3945: U iwl_hw_nic_init ALM-MM type
iwl3945: U iwl_hw_nic_init SKU OP mode is basic
iwl3945: U iwl_hw_nic_init 3945ABG revision is 0xF1
iwl3945: U iwl_hw_nic_init Card M type B version is 0x2
iwl3945: U iwl_load_bsm Begin load bsm
iwl3945: U iwl_verify_bsm Begin verify bsm
iwl3945: U iwl_verify_bsm BSM bootstrap uCode image OK
iwl3945: U iwl_load_bsm BSM write complete, poll 1 iterations
iwl3945: U __iwl_up MAC address: 00:19:d2:42:91:3f
iwl3945: U __iwl_up iwl3945 is coming up
iwl3945: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x9
iwl3945: I iwl_rx_reply_alive Initialization Alive received.
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 900
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 2668
iwl3945: U iwl_verify_ucode Initialize uCode is good in inst SRAM
iwl3945: U iwl_init_alive_start Initialization Alive received.
iwl3945: U iwl_set_ucode_ptrs Runtime uCode pointers are set.
iwl3945: I iwl_rx_reply_alive Alive ucode status 0x00000001 revision 0x1 0x0
iwl3945: I iwl_rx_reply_alive Runtime Alive received.
iwl3945: I iwl_disable_events Selected uCode log events may be disabled
iwl3945: I iwl_disable_events   by writing "1"s into disable bitmap
iwl3945: I iwl_disable_events   in SRAM at 0x8015f4, size 47 u32s
iwl3945: U iwl_alive_start Runtime Alive received.
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 900
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 2668
iwl3945: U iwl_verify_inst_sparse ucode inst image size is 80524
iwl3945: U iwl_verify_ucode Runtime uCode is good in inst SRAM
iwl3945: U iwl_alive_start RFKILL status: 0x1
iwl3945: U iwl_init_channel_map Channel map already initialized.
iwl3945: U iwl_init_geos Geography modes already initialized.
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 94
iwl3945: U iwl_alive_start ALIVE processing complete.
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 131

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

$ cat /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
0

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

$ iwconfig wlan0 essid eMxyzptlk key C1C731EA92AC05B1E7BA6186CF
wlan0     IEEE 802.11g  ESSID:"eMxyzptlk" =20
          Mode:Managed  Frequency:2.462 GHz  Access Point: 00:13:10:1A:07:7=
7  =20
          Bit Rate=3D54 Mb/s   Tx-Power=3Doff  =20
          Retry min limit:7   RTS thr:off   Fragment thr=3D2346 B  =20
          Encryption key:C1C7-31EA-92AC-05B1-E7BA-6186-CF
          Link Quality=3D92/100  Signal level=3D-39 dBm  Noise level=3D-63 =
dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

$ ifconfig wlan0 up; dhclient wlan0
Internet Systems Consortium DHCP Client V3.1.0-Gentoo
Copyright 2004-2007 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/

wmaster0: unknown hardware address type 801
wmaster0: unknown hardware address type 801
Listening on LPF/wlan0/00:19:d2:42:91:3f
Sending on   LPF/wlan0/00:19:d2:42:91:3f
Sending on   Socket/fallback
option_space_encapsulate: option space agent does not exist, but is configu=
red.
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 7
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 7
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 13
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 18
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 15
DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 1
No DHCPOFFERS received.
No working leases in persistent database - sleeping.

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

$ dmesg
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 140
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 144
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 4
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 5
iwl3945: U iwl_mac_conf_tx enter
iwl3945: U iwl_mac_conf_tx leave - queue >=3D AC_NUM 7
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 146
iwl3945: U iwl_mac_start enter
iwl3945: U iwl_mac_start leave
iwl3945: U iwl_mac_add_interface enter: id 10, type 2
iwl3945: U iwl_mac_add_interface Set: 00:19:d2:42:91:3f
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:00:00:00:00:00
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_add_interface leave
iwl3945: U iwl_mac_config_interface enter: interface id 10
iwl3945: U iwl_mac_config_interface bssid: 00:13:10:1a:07:77
iwl3945: U iwl_commit_rxon Sending RXON
* without RXON_FILTER_ASSOC_MSK
* channel =3D 1
* bssid =3D 00:13:10:1a:07:77
iwl3945: U iwl_add_station Add STA ID 24: ff:ff:ff:ff:ff:ff
iwl3945: U iwl_send_add_station REPLY_ADD_STA PASSED
iwl3945: U iwl_mac_config_interface leave
iwl3945: U iwl_mac_set_key enter
iwl3945: U iwl_mac_set_key leave - hwcrypto disabled
ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 147
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 148
iwl3945: U iwl_hw_reg_txpower_get_temperature Temperature: 148

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
( On  Gentoo...)

$ /etc/init.d/net.wlan0 restart
 * Bringing up interface wlan0
 *   Running preup ... *   Wireless radio has been killed for interface wla=
n0
 [ !! ]
 * ERROR: net.wlan0 failed to start

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

$ cat /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill
1

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

As many times as I repeat the above step, even by having=20
    while true;do echo 0 > /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kil=
l; done
it always end up failing to start....

I don't think the problem is rf_kill, it is slightly different from those b=
ugs, it
never takes the value 2 but it takes 1, whatever the problem is, it is caus=
ing
"Tx-Power=3Doff" even If I rmmod/modprobe iwl3945 a 100 times, and loop ech=
oing 0
to /sys/bus/pci/drivers/iwl3945/0000:04:00.0/rf_kill the Tx-Power will be a=
lways off...
A debug of rmmod/modprobe the iwl3945 after all what has been done above is=
 below...

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

$ rmmod iwl3945
$ dmesg
iwl3945: U iwl_pci_remove *** UNLOAD DRIVER ***
iwl3945: U __iwl_down iwl3945 is going down
iwl3945: U iwl_hw_nic_stop_master stop master
iwl3945: U iwl_clear_free_frames 0 frames on pre-allocated heap on clear.
iwl3945: U iwl_mac_remove_interface enter
iwl3945: U iwl_mac_remove_interface leave
iwl3945: U iwl_mac_stop enter
iwl3945: U iwl_mac_stop leave
ACPI: PCI interrupt for device 0000:04:00.0 disabled

$ modprobe iwl3945
$ dmesg
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Lin=
ux, 1.1.17kds
iwl3945: Copyright(c) 2003-2007 Intel Corporation
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:04:00.0 to 64
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
phy3: Selected rate control algorithm 'iwl-3945-rs'
ADDRCONF(NETDEV_UP): wlan0: link is not ready

------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------
------------------------=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D--------------------------

Thanks.

--HlL+5n6rz5pIUxbD--

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHu0f/VWU5RcjdGKIRAqqIAKDG8BHB/WraRszxABdLUx5e3m/iuQCgxFV1
6koWJWhCTTVr13treDh3qeM=
=6e1j
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
