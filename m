Return-Path: <linux-kernel-owner+w=401wt.eu-S935598AbXJPTvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935598AbXJPTvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934219AbXJPTuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:50:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:51696 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765267AbXJPTuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:50:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: ioctl32: Unknown cmd
Date: Tue, 16 Oct 2007 21:50:35 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>
References: <Pine.LNX.4.62.0710161642200.20196@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0710161642200.20196@pademelon.sonytel.be>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710162150.37636.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/53SIBupoKb9jIenuz9PIsZMDC6bhkodEp1+g
 dtws4i1XgmtAVi2aGflOLsaQfKmTNDOyFSW4GOGJZogBVCabJ8
 CdACv3ZFMAn2wSqd4mXMQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2007, Geert Uytterhoeven wrote:
> The recent (post 2.6.23) changes to compat_ioctl made the reporting of
> unsupported ioctls more verbose. E.g. on the PS3 I get:
> 
> | ioctl32(cdrom_id:608): Unknown cmd fd(3) cmd(00005331){t:'S';sz:0} arg(00000000) on /dev/.tmp-11-0
> | ioctl32(hdparm:1427): Unknown cmd fd(3) cmd(0000031f){t:03;sz:0} arg(00000000) on /dev/ps3da
> | ioctl32(hdparm:1427): Unknown cmd fd(3) cmd(0000031f){t:03;sz:0} arg(00000000) on /dev/ps3da
> 
> The first one is triggered by the detection of the CD/DVD/BD-ROM driver,
> The others are triggered by me running hdparm.
> 
> Was this intentional?
> 

No, it was certainly not intentional, and I can't figure out why it happens.
The ioctl numbers from your example are HDIO_DRIVE_CMD and CDROM_GET_CAPABILITY,
both of which should be handled through compat_blkdev_driver_ioctl by calling
the native ioctl method of the driver, and return -ENOTTY otherwise.

The one point where it is expected to have changed now is when you try
to do these ioctls on something that is not a block device. Are you sure that
the files you tried them on were created correctly?

	Arnd <><
