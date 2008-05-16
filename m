Return-Path: <linux-kernel-owner+w=401wt.eu-S1760929AbYEPU0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760929AbYEPU0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 16:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756496AbYEPUZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 16:25:48 -0400
Received: from [158.64.110.160] ([158.64.110.160]:48888 "EHLO
	bonbons.gotdns.org" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752831AbYEPUZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 16:25:47 -0400
From: Bruno =?iso-8859-1?q?Pr=E9mont?= <bonbons@linux-vserver.org>
To: Linux Input <linux-input@vger.kernel.org>
Subject: Input+S3: extra keycodes forgotten after suspend
Date: Fri, 16 May 2008 22:25:43 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805162225.44284.bonbons@linux-vserver.org>
X-VirusProbe: ClamAV, untested
X-SpamProbe: GOOD 0.0000730 878519f9e9a45cf9df1d703b80e8335f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Acer TravelMate 660 I lose keycodes for the extra keys (dritek
extensions) after resume.

The system runs setkeycodes during boot sequence to initialize key codes
for the extra keys as below:

/usr/bin/setkeycodes KEYCODES="e025 138 e026 141 e027 171 e074 148 e073 149 e055 229 e056 230 e057 227 e058 228"
# Fn + F1   ~ e025  => 138 [KEY_HELP] (Help)
# Fn + F2   ~ e026  => 141 [KEY_SETUP] (Notebook Manager)
# Fn + F3   ~ e027  => 171 [KEY_CONFIG] (Power Options)
# Mail      ~ e06c  => 155 [KEY_MAIL] (EMail)
# WWW       ~ e032  => 150 [KEY_WWW] (Browser)
# P1        ~ e074  => 148 [KEY_PROG1] (P1)
# P2        ~ e073  => 149 [KEY_PROG2] (P2)
# Bluetooth ~ e058  => 228 [KEY_BLUETOOTH_DISABLE] (Disable Bluetooth)
# Bluetooth ~ e057  => 227 [KEY_BLUETOOTH_ENABLE] (Enable Bluetooth)
# Wireless  ~ e056  => 230 [KEY_WLAN_DISABLE] (Disable WLAN)
# Wireless  ~ e055  => 229 [KEY_WLAN_ENABLE] (Enable WLAN)
# Vol UP    ~ e030  => 115 [KEY_VOLUMEUP] (Increase Volume)
# Vol DOWN  ~ e02e  => 114 [KEY_VOLUMEDOWN] (Decrease Volume)
# Vol Mute  ~ e020  => 113 [KEY_MUTE] (Mute volume)

After resume I end up with the following messages when pressing the keys:
[  779.695675] atkbd.c: Unknown key pressed (translated set 2, code 0xd6 on isa0060/serio0).
[  779.695675] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.
[  779.705218] atkbd.c: Unknown key released (translated set 2, code 0xd6 on isa0060/serio0).
[  779.705218] atkbd.c: Use 'setkeycodes e056 <keycode>' to make it known.
[  781.603912] atkbd.c: Unknown key pressed (translated set 2, code 0xd5 on isa0060/serio0).
[  781.603912] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
[  781.613564] atkbd.c: Unknown key released (translated set 2, code 0xd5 on isa0060/serio0).
[  781.613564] atkbd.c: Use 'setkeycodes e055 <keycode>' to make it known.
[  782.772662] atkbd.c: Unknown key pressed (translated set 2, code 0xd7 on isa0060/serio0).
[  782.772662] atkbd.c: Use 'setkeycodes e057 <keycode>' to make it known.
[  782.782390] atkbd.c: Unknown key released (translated set 2, code 0xd7 on isa0060/serio0).
[  782.782390] atkbd.c: Use 'setkeycodes e057 <keycode>' to make it known.
[  783.461807] atkbd.c: Unknown key pressed (translated set 2, code 0xd8 on isa0060/serio0).
[  783.461807] atkbd.c: Use 'setkeycodes e058 <keycode>' to make it known.
[  783.471544] atkbd.c: Unknown key released (translated set 2, code 0xd8 on isa0060/serio0).
[  783.471544] atkbd.c: Use 'setkeycodes e058 <keycode>' to make it known.


Is this kind of issue known, what are the options to get kernel to remember the
keycode mappings after s2ram?

System details:
  uname: Linux neptune 2.6.25.4 #8 Fri May 16 20:15:52 CEST 2008 i686 Intel(R)
            Pentium(R) M processor 1500MHz GenuineIntel GNU/Linux
  distro: Gentoo
  suspending with: echo mem > /sys/power/state


Bruno

