Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZCLQiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZCLQiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZCLQiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:38:07 -0400
Received: from [220.248.27.114] ([220.248.27.114]:34510 "EHLO
	arinc.soulinfo.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZCLQiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:38:06 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 12:38:05 EDT
X-Antivirus-MYDOMAIN-Mail-From: hugang@soulinfo.com via arinc
X-Antivirus-MYDOMAIN: 2.02st (Clear:RC:0(221.216.85.36):SA:0(-2.5/5.0):. Processed in 0.175266 secs Process 18614)
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=soulinfo.com;
  b=oRtMF0Ts5jwVXeoqmd7ULRgPjz9iiSo21SA6NTCyvMTZVFM90kIdkHE1+4UDazWVKfAXBv7meQo4q4y0/yBAtxmcMuZhbiGGHsXxupRc9fv+J7rmeCnmxleyYFf0q2i0  ;
Date: Fri, 13 Mar 2009 00:31:19 +0800
From: Hu Gang <hugang@soulinfo.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch]correct the pci window in iop80331.
Message-ID: <20090313003119.15faf644@hugang-macbook>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Importance: high
X-Priority: 1 (Highest)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2CGcLqu028432

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

- -----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Dan Williams:

I found the IOP80331 pci outband windows it not correct, the outboand 
window size is 128Mbyte, split with two 64MByte window, the first outband
translate address is 0x80000000, so the second translate address must 
0x84000000, but in linux kernel it is 0x88000000.

I try to enable the direct windows outband window in iop80331 but not 
work, can you give me some point.

thanks.

- - ------------ patch for fix pci outband window -----------------------
- - --- a/arch/arm/mach-iop3xx/iop331-pci.c
+++ b/arch/arm/mach-iop3xx/iop331-pci.c
@@ -283,7 +283,7 @@ void __init iop3xx_atu_setup(void)
        *IOP331_OUMWTVR0 = 0;

        /* Outbound window 1 */
- - -       *IOP331_OMWTVR1 = IOP331_PCI_LOWER_MEM_PA + IOP3XX_PCI_MEM_WINDOW_SIZE;
+       *IOP331_OMWTVR1 = IOP331_PCI_LOWER_MEM_PA + IOP3XX_PCI_MEM_WINDOW_SIZE/2;
        *IOP331_OUMWTVR1 = 0;

        /* BAR 3 ( Disabled ) */


- - -- 
steve
- - ----------------------------------------------------------------- 
phone  :    010-68920288-818
fax    :    010-68920289
mobile :    13910034252
e-mail :    steve.hu@soulinfo.com
web    :    http://www.soul.com.cn/
- - -----------------------------------------------------------------
- -----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm5DOYACgkQlNo3R5/SzI0nagCfU7imFR6snaCMeACKRNWdA74I
6EUAoItAAksVqyAtuwIq6ynOKsCmSlOg
=LHwl
- -----END PGP SIGNATURE-----
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm5ONcACgkQlNo3R5/SzI0e6QCglfs3ADpdizWF+PqewSAziP3E
1UIAoMMjWzSJ3vE7sg2goLcds37Xd8sE
=LxXn
-----END PGP SIGNATURE-----
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
