Return-Path: <linux-kernel-owner+w=401wt.eu-S1764876AbXJFXpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764876AbXJFXpo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 19:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbXJFXpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 19:45:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:54683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXJFXpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 19:45:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch 1/9] compat_ioctl: move common block ioctls to compat_blkdev_ioctl
Date: Sun, 7 Oct 2007 01:44:26 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <20071006181902.141862534@arndb.de> <20071006182342.566716634@arndb.de> <20071006185509.GA30411@infradead.org>
In-Reply-To: <20071006185509.GA30411@infradead.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710070144.28075.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+BFwJ/iqk9xLmFQjVuxAfldQlkqY4NhNKjE6b
 qmorHHRfCpAvgy/CdZs6M4jBC3RXrhL44Er37PAhxpRj/+0SPW
 Q98Cr597Ez9ngAjZoy5hg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 October 2007, Christoph Hellwig wrote:
> > +static int compat_put_u64(unsigned long arg, u64 val)
> > +{
> > +     return put_user(val, (compat_u64 __user *)compat_ptr(arg));
> > +}
> 
> These should probably be in compat.h

Hmm, I'm not sure. They are modeled after the put_{short,int,uint,...}
functions that only exist in block/ioctl.c and I put them in so I
could use almost identical code in the native and compat path.

If we find these generally useful, I guess we could have both
versions of each of these functions in global headers, e.g. in
linux/uaccess.h and linux/compat.h, but right now I would recommend
using plain put_user in all compat code except for block ioctl.

	Arnd <><
