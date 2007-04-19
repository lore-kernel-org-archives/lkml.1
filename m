Return-Path: <linux-kernel-owner+w=401wt.eu-S1766795AbXDSPJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766795AbXDSPJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766791AbXDSPJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:09:30 -0400
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:59233 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766786AbXDSPJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:09:29 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cciss: Fix warnings during compilation under 32bit  environment
Date: Thu, 19 Apr 2007 15:09:10 -0000
Message-ID: <226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
In-Reply-To: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cciss: Fix warnings during compilation under 32bit  environment
thread-index: AceBh6+soEuZ7NtlQ2KNjFcJtPC/PQBDK0NQ
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: "Hisashi Hifumi" <hifumi.hisashi@oss.ntt.co.jp>,
       <akpm@linux-foundation.org>
Cc: <jens.axboe@oracle.com>, <linux-kernel@vger.kernel.org>,
       <linux-scsi@vger.kernel.org>, "Cameron, Steve" <steve.cameron@hp.com>
X-OriginalArrivalTime: 19 Apr 2007 15:09:20.0074 (UTC) FILETIME=[B4A39AA0:01C78294]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Hisashi Hifumi [mailto:hifumi.hisashi@oss.ntt.co.jp] 
> Sent: Wednesday, April 18, 2007 2:03 AM
> To: Miller, Mike (OS Dev); akpm@linux-foundation.org
> Subject: [PATCH] cciss: Fix warnings during compilation under 
> 32bit environment
> 
> 
> Hi.
> 
> I fixed following warnings.
> 
> drivers/block/cciss.c: In function `do_cciss_request':
> drivers/block/cciss.c:2555: warning: right shift count >= 
> width of type
> drivers/block/cciss.c:2556: warning: right shift count >= 
> width of type
> drivers/block/cciss.c:2557: warning: right shift count >= 
> width of type
> drivers/block/cciss.c:2558: warning: right shift count >= 
> width of type
> 
> 
> Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

Nak. You still haven't told where you saw these warnings. What compiler
are you using? I do not see these in my 32-bit environment.

mikem

> 
> 
> --- linux-2.6.21-rc7.org/drivers/block/cciss.c	2007-04-17 
> 16:36:02.000000000 +0900
> +++ linux-2.6.21-rc7/drivers/block/cciss.c	2007-04-17 
> 16:25:53.000000000 +0900
> @@ -2552,10 +2552,10 @@ static void do_cciss_request(request_que
>   	} else {
>   		c->Request.CDBLen = 16;
>   		c->Request.CDB[1]= 0;
> -		c->Request.CDB[2]= (start_blk >> 56) & 0xff;	//MSB
> -		c->Request.CDB[3]= (start_blk >> 48) & 0xff;
> -		c->Request.CDB[4]= (start_blk >> 40) & 0xff;
> -		c->Request.CDB[5]= (start_blk >> 32) & 0xff;
> +		c->Request.CDB[2]= sizeof(start_blk) > 4 ? 
> (start_blk >> 56) & 0xff : 0;	//MSB
> +		c->Request.CDB[3]= sizeof(start_blk) > 4 ? 
> (start_blk >> 48) & 0xff : 0;
> +		c->Request.CDB[4]= sizeof(start_blk) > 4 ? 
> (start_blk >> 40) & 0xff : 0;
> +		c->Request.CDB[5]= sizeof(start_blk) > 4 ? 
> (start_blk >> 32) & 0xff : 
> +0;
>   		c->Request.CDB[6]= (start_blk >> 24) & 0xff;
>   		c->Request.CDB[7]= (start_blk >> 16) & 0xff;
>   		c->Request.CDB[8]= (start_blk >>  8) & 0xff;
> 
> 
> 
> Thanks,
> 
