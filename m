Return-Path: <linux-kernel-owner+w=401wt.eu-S1762613AbXGEU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762613AbXGEU3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759803AbXGEU3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:29:31 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:54154 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605AbXGEU3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:29:30 -0400
From: Chr <chunkeey@web.de>
To: Thorsten Leemhuis <thl@ct.heise.de>
Subject: Re: [patch 2.6.22-rc6] ATA: add a PCI ID for Intel Santa Rosa PATA controller
Date: Thu, 5 Jul 2007 22:30:24 +0200
User-Agent: KMail/1.9.7
Cc: Thorsten Leemhuis <fedora@leemhuis.info>,
       Chuck Ebbert <cebbert@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jason Gaston <jason.d.gaston@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       chunkeey@web.de
References: <468408F1.3080307@redhat.com> <200707021636.25192.chunkeey@web.de> <468BA8B0.8030606@ct.heise.de>
In-Reply-To: <468BA8B0.8030606@ct.heise.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hTVjG1tpSo5WFUy"
Message-Id: <200707052230.25310.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1+hKlfTeuUVVuyeBZOwnIpipcdgekKmk6P8PLfd
	v1m5ZeIERtwwCNykDJnGfBXEdRQ3xqXG+2+uwVtaUkS3ffTNI4
	QUnyMPC/g=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_hTVjG1tpSo5WFUy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday, 4. July 2007, Thorsten Leemhuis wrote:
>
> Maybe Alan or someone from Intel can answer that and thus tell us how to
> move forward; it would be really nice to get the patch that started this
> thread (it got posted by Chuck again today) could go into 2.6.22, but I
> assume the time runs away...
>
Jeff is on holiday and Intel doesn't respond at all... 

So, if someone has a ICH5 or ICH7/7-R with a ATA133 captable HDD... could
you please try the following patch? (Of course, I don't know if it works,...
It may cause data loss, serve corruption, or damage your controller/hdd/pc,
so make backups and keep a first-aid kit handy!) 
  
> > On the other hand, we can leave it, because of a "off-by-one error" in ata_piix.c, 
> > do_pata_set_dmamode, line ~770:
> > [...]
> 

Thanks,
	Chr.


--Boundary-00=_hTVjG1tpSo5WFUy
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="don_t_try_this_if_you_don_t_know_what_it_does.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="don_t_try_this_if_you_don_t_know_what_it_does.patch"

--- a/drivers/ata/ata_piix.c	2007-06-19 12:19:39.000000000 +0200
+++ b/drivers/ata/ata_piix.c	2007-07-05 22:11:52.000000000 +0200
@@ -767,8 +767,8 @@
 		 *	       except UDMA0 which is 00
 		 */
 		u_speed = min(2 - (udma & 1), udma);
-		if (udma == 5)
-			u_clock = 0x1000;	/* 100Mhz */
+		if (udma >= 5)
+			u_clock = 0x1000;	/* 133Mhz */
 		else if (udma > 2)
 			u_clock = 1;		/* 66Mhz */
 		else

--Boundary-00=_hTVjG1tpSo5WFUy--
