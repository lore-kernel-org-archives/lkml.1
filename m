Return-Path: <linux-kernel-owner+w=401wt.eu-S932882AbXH3SWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbXH3SWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932285AbXH3SWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:22:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60386 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbXH3SWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:22:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
Date: Thu, 30 Aug 2007 20:22:23 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070508.662491)
Cc: Joachim Fenkes <fenkes@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>, Thomas Klein <tklein@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200708291815.18197.fenkes@de.ibm.com>
In-Reply-To: <200708291815.18197.fenkes@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708302022.24167.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18+Pa5JH+jT2OR66t1/IQa5+mw+8wQwRewUJL0
 ovfj15JoUe5UT9fa/eifU1eUTFRN65ZvVGYPd2BHiu3FzSA16U
 Y9Rzq6E26xD0rocz+Zxiw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 August 2007, Joachim Fenkes wrote:
> Previously, ibmebus derived a device's bus_id from its location code. The
> location code is not guaranteed to be unique, so we might get bus_id
> collisions if two devices share the same location code. The OFDT full_name,
> however, is unique, so we use that instead.
> 
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>

Actually, I think it would be much better to convert the code to be more
like of_platform_device, or to even replace all of ibmebus with that.

The whole logic of dynamically adding and removing device is rather bogus,
and it prevents autoloading of device drivers. of_platform_make_bus_id
is the function that is responsible for creating unique names over there.

	Arnd <><
