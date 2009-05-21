Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZEUPjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZEUPjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 11:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZEUPi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 11:38:56 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:65134 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZEUPiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 11:38:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ifZHxITx7aawTQnbtobMACu199mEBa5Dr229nwQ1Im+UuRjJLplo9X0DgvDTO1VHMm
         Lh+lCf9bNQlL/Gu3AGVUCNdWrg1wnQBCv4GfNXPn4y8n1UlZOfv03v5FOCxh7vkhM3jr
         ZPPNgfHdmwXKJC2Zoj5sv57I+QhMW2bB4b0n8=
Date: Thu, 21 May 2009 17:38:39 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, ariveira@gmail.com
Subject: [mac80211 ] Wifi Network slownes bisected
Message-ID: <20090521173839.1f20b95d@varda>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4LFdNlL023690

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256


 I have a rt2500pci card

 I noticed that my wifi connection has slowed when stitching
from 2.6.29.1 to 2.6.29.4 (it is also slow on 30-rc6)
Also 2.6.27 (ubuntu) does not suffer it.

 I bisected and came to the following commit as the culprit

 I can test patches and if you need more info just ask.

$ git bisect good
64e1b00c974ddeae6a60ebb02e1c487371905cea is first bad commit
commit 64e1b00c974ddeae6a60ebb02e1c487371905cea
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Fri Apr 24 16:05:16 2009 +0000

    mac80211: fix basic rate bitmap calculation
    
    upstream commit: 7e0986c17f695952ce5d61ed793ce048ba90a661
    
    "mac80211: fix basic rates setting from association response"
    introduced a copy/paste error.
    
    Unfortunately, this not just leads to wrong data being passed
    to the driver but is remotely exploitable for some hardware or
    driver combinations.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>
    Signed-off-by: Chris Wright <chrisw@sous-sol.org>

:040000 040000 e9e479210b46ae45f9c84badd57039df44d4077c
ea0b719e549849446e62e065b2570fab5a801895 M      net

 Bisect Log
$ git bisect log
git bisect start
# bad: [186f9b18b94afd0b75a8ec1b394b0f119d479eb6] Linux 2.6.29.4
git bisect bad 186f9b18b94afd0b75a8ec1b394b0f119d479eb6
# good: [8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84] Linux 2.6.29
git bisect good 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84
# good: [fda28853bc4bc053ef2fafb5c7d2a26e6ce4b4bf] KVM: Fix missing smp tlb flush in invlpg
git bisect good fda28853bc4bc053ef2fafb5c7d2a26e6ce4b4bf
# bad: [7843dcfe1115e9412e6e83492e17f9c75b5a062d] mv643xx_eth: OOM handling fixes
git bisect bad 7843dcfe1115e9412e6e83492e17f9c75b5a062d
# bad: [87b59eac0914ab407df57fe23d880dccd9a9436d] virtio-rng: Remove false BUG for spurious callbacks
git bisect bad 87b59eac0914ab407df57fe23d880dccd9a9436d
# good: [24016c735e651f179692432f18176348caeb82b0] scsi: mpt: suppress debugobjects warning
git bisect good 24016c735e651f179692432f18176348caeb82b0
# good: [5c47524b514b5bb3732c3b893338a210d67da3cd] thinkpad-acpi: fix LED blinking through timer trigger
git bisect good 5c47524b514b5bb3732c3b893338a210d67da3cd
# bad: [d595990048ad17ba7b0ad50438ed64f88b7c25ca] KVM: MMU: disable global page optimization
git bisect bad d595990048ad17ba7b0ad50438ed64f88b7c25ca
# bad: [64e1b00c974ddeae6a60ebb02e1c487371905cea] mac80211: fix basic rate bitmap calculation
git bisect bad 64e1b00c974ddeae6a60ebb02e1c487371905cea
# good: [d2d83e1f527b6b0faf15d54b22c032ed5812d054] ALSA: us122l: add snd_us122l_free()
git bisect good d2d83e1f527b6b0faf15d54b22c032ed5812d054

 



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBCAAGBQJKFXV/AAoJEDO4iEReSTB26+UP/ixsfr571yVpCkmemShNGJjF
qThmtl+zZLxO+O1ok3M/K57DwptyBMdgx2zOQ9PqQatN2g2gyXaFd3R0MJnNr4Sn
xQPEBtRALXHvC5b2KxhfgECN1+N3SsB4CK5dUzWepP/Dc16zt0pEXU/ZV7P7v0Ey
r8tvY4tPThnHcy/QeQLJuQaechjBEmx1/bN+ZrC5s6wlerHC9Sj/hd5YApTlu9k6
orRQRIv1jQ4UpU3Mr16Ax5EtrspLxBcnf1AxYTln+GKsIg2Q108mTOzwU9ZGu4I8
fEhYbbpThSYx6FR6APtkzOez4BkA97eT4fjpFUKdIauVY+omiTbebLQiwqwLDGhW
BLL3x4jMWEzSi1sYGk3q+Z4T8BEKqLsJVrERZZIS/1UCynNBCCxEm+hUOKE3z+Il
QsdVBTp43cbWhH2zlbg9sAb+dQ0zxLQ5JEN9JhNVoXGkz3JUJ+vYeI+R4hHONBzA
7nCHVguHNitb94M/rhRf3PVlfI4+UWLKjegw6+Myl/AQnzDc2+iuHK2A2vVDeMN1
7sagdKGizojeS7Mb/i5WAX2E2Gu2HYuCWhVzhiAv3v2kCem1IFVlyFkqFOF6/qxN
fcVOCBmgRVyZogfDgQJA8q4dypMyouWFaTd483tawglHzp3tscd6AlyuO8W1jfan
xuz7EjfXE8YJWc4NKiJq
=Xy0O
-----END PGP SIGNATURE-----
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
