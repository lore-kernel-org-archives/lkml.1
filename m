Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYCJNGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYCJNGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753593AbYCJNGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:06:03 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:3203 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbYCJNGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=fF7h1mLOHTUkotU419laX+sxhBiVWjYSbVQETgfpf581O09S/VbasfDRlabt2lK4J/cJvAg/rNu1WYQwEGJ8trOzD/fY+Q6n9Xk6bGlrtHk1bSuEsiSFSy5YPfcgduezGz2uTC66Uao6MmKsQcpeC4102b9OsgRxGx/0bMLC4qU=
Message-ID: <47D53231.30107@gmail.com>
Date: Mon, 10 Mar 2008 22:05:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org
Subject: Re: Unknown SATA PIIX PCI device ID 0x29b6
References: <Pine.LNX.4.64.0802282306190.10087@axis700.grange> <20080228225603.2764bfd1@core> <Pine.LNX.4.64.0802290010320.10498@axis700.grange> <47CFADDF.20200@gmail.com> <Pine.LNX.4.64.0803061248070.5670@axis700.grange> <47D0C9E6.8090301@gmail.com> <Pine.LNX.4.64.0803082345000.6749@axis700.grange> <47D3723B.3040700@gmail.com> <Pine.LNX.4.64.0803092221560.7385@axis700.grange> <47D485EC.1060103@gmail.com> <Pine.LNX.4.64.0803100821440.3948@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0803100821440.3948@axis700.grange>
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------050508050404020705010406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050508050404020705010406
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Guennadi Liakhovetski wrote:
> On Mon, 10 Mar 2008, Tejun Heo wrote:
> 
>>> Yctually it was 2.6.24 before, rebuilt 2.6.25-rc4, booted as above, it did 
>>> say:
>>>
>>> ata4: FORCE: PHY spd limit set to 1.5Gbps
>>>
>>> but hot-plugging the drive still took 50 seconds to recover.
>> How about cold plugging?
> 
> Same.

Does the attached patch help?

-- 
tejun

--------------050508050404020705010406
Content-Type: text/plain;
 name="debug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="debug"

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

Index: tree2/drivers/ata/ahci.c
===================================================================
--- tree2.orig/drivers/ata/ahci.c
+++ tree2/drivers/ata/ahci.c
@@ -397,6 +397,7 @@ static const struct ata_port_operations 
 static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci */
 	{
+		AHCI_HFLAGS	(AHCI_HFLAG_NO_PMP),
 		.flags		= AHCI_FLAG_COMMON,
 		.link_flags	= AHCI_LFLAG_COMMON,
 		.pio_mask	= 0x1f, /* pio0-4 */

--------------050508050404020705010406--
