Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYHXKfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYHXKfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 06:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYHXKf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 06:35:27 -0400
Received: from smtp14.mtu.ru ([62.5.255.60]:49600 "EHLO smtp14.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbYHXKf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 06:35:26 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Aug 2008 06:35:26 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: What is "extra timer interrupt" in powertop output?
Date: Sun, 24 Aug 2008 14:26:33 +0400
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc4-1avb; KDE/4.1.0; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1511446.SVBrXjt2my";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200808241426.34304.arvidjaar@mail.ru>
X-DCC-STREAM-Metrics: smtp14.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1511446.SVBrXjt2my
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

After disabling CD-ROM polling the next top-100 winner is "extra timer=20
interrupt":

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 4.2%)          750 Mhz     0.0%
polling           0.0ms ( 0.0%)          500 Mhz   100.0%
C1                0.0ms ( 0.0%)
C2                0.9ms (95.8%)


Wakeups-from-idle per second : 1101.2   interval: 5.0s
Power usage (ACPI estimate): 11.7W (2.2 hours)

Top causes for wakeups:
  31.6% (  8.4)       <interrupt> : extra timer interrupt
  15.0% (  4.0)   hald-addon-acpi : schedule_timeout (process_timeout)

I assume, this is what is simply called "timer":
{pts/1}:~%> cat /proc/interrupts
           CPU0
  0:    9060975    XT-PIC-XT        timer
  1:      18742    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:          2    XT-PIC-XT
  4:          2    XT-PIC-XT
  5:          3    XT-PIC-XT
  7:          5    XT-PIC-XT        irda0
  8:         11    XT-PIC-XT        rtc0
  9:       3376    XT-PIC-XT        acpi
 10:          2    XT-PIC-XT
 11:     239251    XT-PIC-XT        ohci_hcd:usb1, yenta, yenta, yenta, ALI=
=20
5451, pcmcia0.0
 12:     621206    XT-PIC-XT        i8042
 14:     225993    XT-PIC-XT        ide0
 15:     315463    XT-PIC-XT        ide1
NMI:          0   Non-maskable interrupts
ERR:          0

Any way to find out why there are so many of them? System is using dynamic=
=20
ticks:
{pts/1}:~/src/linux-git%> grep NO_HZ /boot/config
CONFIG_NO_HZ=3Dy

TIA

=2Dandrey



--nextPart1511446.SVBrXjt2my
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkixN1oACgkQR6LMutpd94xODACfdxGbx3xelWbnsEenobbmuM8P
G1QAoMbg83kNOJjeJwXENziR+zEFj8Ai
=B76G
-----END PGP SIGNATURE-----

--nextPart1511446.SVBrXjt2my--
