Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbXJTQXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbXJTQXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 12:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbXJTQX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 12:23:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:57902 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbXJTQX2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 12:23:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] compat_ioctl: introduce generic_compat_ioctl helper
Date: Sat, 20 Oct 2007 18:23:07 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Al Viro <viro@ftp.linux.org.uk>, Philip Langdale <philipl@overt.org>,
       Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>
References: <47100864.2090208@overt.org> <200710201750.58521.arnd@arndb.de> <20071020161119.GA22065@infradead.org>
In-Reply-To: <20071020161119.GA22065@infradead.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710201823.07791.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/gfaMdaqXbMgElHmMZ9gbpgCiXVn32Fmk+xct
 uVrZpNdkcQxE9BqwUmrUGqofQaGWnSJ1E67mYSJPPcITBntRuF
 DHvwICFuR6yHeHwDC/Myw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 October 2007, Christoph Hellwig wrote:
> At least for the unlocked_ioctl case this is not nessecary because
> the driver an simply set both the unlocked_ioctl and compat_ioctl
> handlers to the same function.  For the drivers not using unlocked_ioctl
> yet a function like this makes sense in theory, but I'd prefer to
> just switch them to ->unlocked_ioctl.
> 

There is still the problem with s390 compat_ptr() conversion, a driver
using the same handler for both may interpret a pointer with the high
bit set as out of range.

	Arnd <><
