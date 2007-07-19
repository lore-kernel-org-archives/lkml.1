Return-Path: <linux-kernel-owner+w=401wt.eu-S938842AbXGSO5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938842AbXGSO5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757870AbXGSO4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:56:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60133 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbXGSO4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:56:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [Cbe-oss-dev] [patch 11/13] cell: driver for DDR2 memory on AXON
Date: Thu, 19 Jul 2007 16:49:27 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070718160439.723093835@arndb.de> <200707190048.09686.arnd@arndb.de> <20070719101230.GA4553@lst.de>
In-Reply-To: <20070719101230.GA4553@lst.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707191649.27976.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18eej+Fo5moU3DZKVuU6CvqY/Ey3dOget5qCGB
 /VQzYHN45ZGqgs8dW051/SKtPaAZOtmbbZi40DHJ0aHihJzTru
 LROHCRF/0g34msSqd8g1g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007, Christoph Hellwig wrote:
> 
> > None of these seems to make any difference whatsoever, except for BLKBSZGET
> > returning non-zero on a ramdisk or dcssblk device. I think we'd be best
> > off removing bd_block_size from the kernel altogether, and I'll remove
> > it from the axon-ram driver now.
> 
> Yes, please.  I even have patches that only pass struct gendisk to block
> device ->open, so this couldn't work anymore anyway.  And yes, the
> ramdisk driver is doing some really odd things.

Any suggestion on what BLKBSZGET should return?

1) blocksize = 0 (same as it does already for most devices)
2) return -EINVAL
3) same as BLKSSZGET
4) return -ENOTTY

It probably doesn't matter much as any user of BLKBSZGET is
already broken, but it would be good to do the right thing
since it is a documented interface.

	Arnd <><
