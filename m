Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZCLQmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZCLQmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbZCLQmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:42:25 -0400
Received: from [124.193.126.98] ([124.193.126.98]:50488 "EHLO dyn.soulinfo.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754879AbZCLQmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:42:24 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 12:42:24 EDT
X-Antivirus-MYDOMAIN-Mail-From: hugang@bj.soulinfo.com via bj
X-Antivirus-MYDOMAIN: 2.02st (Clear:RC:0(221.216.85.36):SA:0(?/?):. Processed in 30.242652 secs Process 22529)
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=bj.soulinfo.com;
  b=KbMKOcbebhnS1CuQl6389Sa+dilE7qPeyLNyDz/fVlNZGdRo6R7NE9TUFfXzcPsIBtMKbZywIzH8S4ur+XTbOpIKyzQRHVqDcmCA4bOXRH421ZFxEW6PAwT1kAib7j4W  ;
Date: Fri, 13 Mar 2009 00:35:07 +0800
From: Hu Gang <hugang@bj.soulinfo.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [patch]correct the pci window in iop80331.
Message-ID: <20090313003507.153d6cbf@hugang-macbook>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Importance: high
X-Priority: 1 (Highest)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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


-- 
steve
----------------------------------------------------------------- 
phone  :    010-68920288-818
fax    :    010-68920289
mobile :    13910034252
e-mail :    steve.hu@soulinfo.com
web    :    http://www.soul.com.cn/
-----------------------------------------------------------------
