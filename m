Return-Path: <linux-kernel-owner+w=401wt.eu-S1030634AbXEPVn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030634AbXEPVn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 17:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760630AbXEPVnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 17:43:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:52073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759818AbXEPVns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 17:43:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: Slab allocators: Define common size limitations
Date: Wed, 16 May 2007 23:42:07 +0200
User-Agent: KMail/1.9.6
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0705152313490.5832@schroedinger.engr.sgi.com> <Pine.LNX.4.62.0705160855470.24080@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0705160855470.24080@pademelon.sonytel.be>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705162342.08601.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/0bb6oWZzgE6Mwbbp9WMBUQ6Ky701sf/VYl3q
 n/uAL5ilHW8m1Z42wCsw48WNiTg38sZE+sHZJUwxQbkRl5zmef
 wSZMqUIoz1yBhMZ4TQsUQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007, Geert Uytterhoeven wrote:
> What are the changes a large allocation will actually succeed?
> Is there an alignment rule for large allocations?
> 
> E.g. for one of the PS3 drivers I need a physically contiguous 256 KiB-aligned
> block of 256 KiB. Currently I'm using __alloc_bootmem() for that, but maybe
> kmalloc() becomes a suitable alternative now?

kmalloc is limited to 128KiB on most architectures. Normally there is no
need to use it anyway, just use __get_free_pages(). It will generally
succeed at early boot time, but not after the system has been running
for some time.

	Arnd <><
