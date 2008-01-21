Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbYAUXYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbYAUXYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760800AbYAUXTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:19:53 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:41232 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760276AbYAUXTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:51 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: LKML <linux-kernel@vger.kernel.org>
Subject: Rescheduling interrupts
Date: Tue, 22 Jan 2008 01:19:38 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080118.763038)
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1463599.L3vYDv7SIA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801220119.42312.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1463599.L3vYDv7SIA
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

With Linus's latest git, powertop reports following while system nearly %10=
0=20
idle;

PowerTOP version 1.9       (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 6,3%)         1,84 Ghz     0,4%
C1                0,0ms ( 0,0%)         1333 Mhz     0,0%
C2                0,1ms ( 0,5%)         1000 Mhz    99,6%
C3                3,7ms (93,2%)


Wakeups-from-idle per second : 306,8    interval: 10,0s
Power usage (5 minute ACPI estimate) :  23,1 W (0,5 hours left)

Top causes for wakeups:
  59,9% (238,4)      <kernel IPI> : Rescheduling interrupts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^
  14,7% ( 58,6)         amarokapp : schedule_timeout (process_timeout)
   5,5% ( 21,9)              java : futex_wait (hrtimer_wakeup)
   5,0% ( 19,8)       <interrupt> : iwl3945
   2,5% ( 10,0)              java : schedule_timeout (process_timeout)
   2,5% ( 10,0)     <kernel core> : ehci_work (ehci_watchdog)
   2,5% ( 10,0)       <interrupt> : extra timer interrupt
   1,6% (  6,4)             artsd : schedule_timeout (process_timeout)
   1,0% (  4,0)   <kernel module> : usb_hcd_poll_rh_status (rh_timer_func)
   0,5% (  2,0)       <interrupt> : ohci1394, uhci_hcd:usb4, nvidia
   0,5% (  2,0)     <kernel core> : clocksource_check_watchdog=20
(clocksource_watchdog)
   0,5% (  2,0)              kwin : schedule_timeout (process_timeout)
   0,5% (  1,9)    wpa_supplicant : schedule_timeout (process_timeout)
   0,3% (  1,2)          kdesktop : schedule_timeout (process_timeout)
   0,3% (  1,0)          kwrapper : do_nanosleep (hrtimer_wakeup)
   0,3% (  1,0)           klipper : schedule_timeout (process_timeout)
   0,3% (  1,0)             artsd : do_setitimer (it_real_fn)
   0,3% (  1,0)         gpg-agent : schedule_timeout (process_timeout)
   0,3% (  1,0)                 X : nv_start_rc_timer (nv_kern_rc_timer)
   0,3% (  1,0)            kicker : schedule_timeout (process_timeout)
   0,1% (  0,5)           iwl3945 : ieee80211_authenticate=20
(ieee80211_sta_timer)
   0,1% (  0,5)     <kernel core> : neigh_table_init_no_netlink=20
(neigh_periodic_timer)

This "<kernel IPI> : Rescheduling interrupts" causes at least 200 wakeups=20
(sometimes i see ~400 wakeups) for me and a quick google search yields [1],=
=20
but i didn't see this reported to LKML, so here it is :).

If anything else is needed please yell...

[1] http://www.mail-archive.com/power@bughost.org/msg01009.html
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1463599.L3vYDv7SIA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBHlSiOy7E6i0LKo6YRAmADAJ9MmCHhIgHk3oUsBce4kWiuT0LJLACfZZki
UaWfTAkLV4risW7Weg03Brg=
=KeAV
-----END PGP SIGNATURE-----

--nextPart1463599.L3vYDv7SIA--
