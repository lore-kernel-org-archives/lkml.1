Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbXFUXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbXFUXXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 19:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbXFUXXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 19:23:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51604 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbXFUXXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 19:23:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Carsten Otte <cotte@de.ibm.com>
Subject: Re: [BUG?]Set XIP mount option on ext2 bypass check.
Date: Fri, 22 Jun 2007 01:22:41 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Yan Zheng <yanzheng@21cn.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4679A58C.2080008@21cn.com> <467A5E36.9030904@de.ibm.com> <1182431869.7145.7.camel@cotte.boeblingen.de.ibm.com>
In-Reply-To: <1182431869.7145.7.camel@cotte.boeblingen.de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706220122.41586.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/fune8PYKZ2fD54khGQw6fThRX8diJv0yWfvS
 J4PdgDrpjuoYzHp8MFFH9sRTZdQZrEGE7lCn5dzSmoWFVT3tL/
 2XEuyu1Nivvub9UkkfcnQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2007, Carsten Otte wrote:
> 
> This is an updated version of my bugfix patch. Yan Zheng pointed out,
> that ext2_remount lacks checking if -o xip should be enabled or not.
> This patch checks for presence of direct_access on the backing block
> device and if the blocksize meets the requirements.
> Andrew, please consider adding this patch to -mm.
> 
> Signed-off-by: Carsten Otte <cotte@de.ibm.com>

It looks to me like a local denial of service attack in case of
user-mountable ext2 file systems in /etc/fstab.

Shouldn't that make it go into 2.6.22?

	Arnd <><
