Return-Path: <linux-kernel-owner+w=401wt.eu-S932371AbXGaRhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbXGaRhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760438AbXGaRhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:37:35 -0400
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:57986 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbXGaRhd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:37:33 -0400
X-Greylist: delayed 1374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 13:37:33 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 07] drivers/block/cciss.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 17:14:12 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8C01A3EDE7@G3W0639.americas.hpqcorp.net>
In-Reply-To: <200707311903.52301.m.kozlowski@tuxland.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 07] drivers/block/cciss.c: kmalloc + memset conversion to kzalloc
Thread-Index: AcfTlNDoaRvRQjsIQEqEsyCaFMf5pgAAU60Q
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707311903.52301.m.kozlowski@tuxland.pl>
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       <linux-kernel@vger.kernel.org>
Cc: <kernel-janitors@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "ISS StorageDev" <iss_storagedev@hp.com>, <axboe@kernel.dk>
X-OriginalArrivalTime: 31 Jul 2007 17:14:13.0809 (UTC) FILETIME=[37CD1210:01C7D396]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Mariusz Kozlowski [mailto:m.kozlowski@tuxland.pl] 
> Sent: Tuesday, July 31, 2007 12:04 PM
> To: linux-kernel@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; Andrew Morton; ISS 
> StorageDev; axboe@kernel.dk
> Subject: [PATCH 07] drivers/block/cciss.c: kmalloc + memset 
> conversion to kzalloc
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Acked-by: Mike Miller <mike.miller@hp.com>

> 
>  drivers/block/cciss.c | 104285 -> 104168 (-117 bytes)  
> drivers/block/cciss.o | 277400 -> 277124 (-276 bytes)
> 
>  drivers/block/cciss.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1-a/drivers/block/cciss.c	
> 2007-07-26 13:07:41.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/drivers/block/cciss.c	
> 2007-07-31 12:57:50.000000000 +0200
> @@ -1977,12 +1977,13 @@ cciss_read_capacity(int ctlr, int logvol  {
>  	ReadCapdata_struct *buf;
>  	int return_code;
> -	buf = kmalloc(sizeof(ReadCapdata_struct), GFP_KERNEL);
> -	if (buf == NULL) {
> +
> +	buf = kzalloc(sizeof(ReadCapdata_struct), GFP_KERNEL);
> +	if (!buf) {
>  		printk(KERN_WARNING "cciss: out of memory\n");
>  		return;
>  	}
> -	memset(buf, 0, sizeof(ReadCapdata_struct));
> +
>  	if (withirq)
>  		return_code = sendcmd_withirq(CCISS_READ_CAPACITY,
>  				ctlr, buf, 
> sizeof(ReadCapdata_struct), @@ -2003,7 +2004,6 @@ 
> cciss_read_capacity(int ctlr, int logvol
>  		printk(KERN_INFO "      blocks= %llu block_size= %d\n",
>  		(unsigned long long)*total_size+1, *block_size);
>  	kfree(buf);
> -	return;
>  }
> 
>  static void
> @@ -2011,12 +2011,13 @@ cciss_read_capacity_16(int ctlr, int log  {
>  	ReadCapdata_struct_16 *buf;
>  	int return_code;
> -	buf = kmalloc(sizeof(ReadCapdata_struct_16), GFP_KERNEL);
> -	if (buf == NULL) {
> +
> +	buf = kzalloc(sizeof(ReadCapdata_struct_16), GFP_KERNEL);
> +	if (!buf) {
>  		printk(KERN_WARNING "cciss: out of memory\n");
>  		return;
>  	}
> -	memset(buf, 0, sizeof(ReadCapdata_struct_16));
> +
>  	if (withirq) {
>  		return_code = sendcmd_withirq(CCISS_READ_CAPACITY_16,
>  			ctlr, buf, 
> sizeof(ReadCapdata_struct_16), @@ -2038,7 +2039,6 @@ 
> cciss_read_capacity_16(int ctlr, int log
>  	printk(KERN_INFO "      blocks= %llu block_size= %d\n",
>  	       (unsigned long long)*total_size+1, *block_size);
>  	kfree(buf);
> -	return;
>  }
> 
>  static int cciss_revalidate(struct gendisk *disk)
> 
