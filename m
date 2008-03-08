Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYCHWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYCHWrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 17:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYCHWrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 17:47:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:52671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751805AbYCHWrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 17:47:08 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX183a/o/0Y034zsgkxhck8/aFTGvEED9NzNWX/J/km
	m4/HC/43UhNNDL
Date: Sat, 8 Mar 2008 23:47:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Tejun Heo <htejun@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: Unknown SATA PIIX PCI device ID 0x29b6
In-Reply-To: <47D0C9E6.8090301@gmail.com>
Message-ID: <Pine.LNX.4.64.0803082345000.6749@axis700.grange>
References: <Pine.LNX.4.64.0802282306190.10087@axis700.grange>
 <20080228225603.2764bfd1@core> <Pine.LNX.4.64.0802290010320.10498@axis700.grange>
 <47CFADDF.20200@gmail.com> <Pine.LNX.4.64.0803061248070.5670@axis700.grange>
 <47D0C9E6.8090301@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008, Tejun Heo wrote:

> > Looks like almost a minute to me? On another occurence I see about 1.5 
> > minutes, then "port is slow to respond, please be patient (Status 0x80)" 
> > has been repeated 3 times. On cold-plug also 3 times, I think, about the 
> > same time then (time is not updated in the log).
> 
> I see.  Does the attached patch make any difference?

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4fbcce7..abebdcc 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6712,6 +6712,7 @@ int sata_link_init_spd(struct ata_link *link)
 	spd = (scontrol >> 4) & 0xf;
 	if (spd)
 		link->hw_sata_spd_limit &= (1 << spd) - 1;
+	link->hw_sata_spd_limit = 1;
 
 	ata_force_spd_limit(link);
 
Hm, this would force 1.5Gbps on all ports and devices, right? Cannot I 
just boot with "libata.force=4:1.5Gbps"?

Thanks
Guennadi
---
Guennadi Liakhovetski
