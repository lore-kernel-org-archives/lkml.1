Return-Path: <linux-kernel-owner+w=401wt.eu-S2992466AbXDCWu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992466AbXDCWu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992476AbXDCWu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:50:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59577 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992466AbXDCWuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:50:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: A set of "standard" virtual devices?
Date: Wed, 4 Apr 2007 00:49:11 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Andi Kleen <ak@suse.de>,
       Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <200704032351.17823.arnd@arndb.de> <4612D0CA.3070209@zytor.com>
In-Reply-To: <4612D0CA.3070209@zytor.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704040049.13118.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19JSvumoZmdoNyTgMDCWBdzcVN1qo/+fwehK0P
 50O12oEYOeDS3i6UAeeroRI+mt4lmIQSvp5/HkQffMkKBn5RhS
 ArC/a1J7iPMAoRWTxz4yw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 April 2007, H. Peter Anvin wrote:
> Note that at least for PIO-based devices, there is nothing that says you 
> can't implement PCI over another transport, if you wish.  It's really 
> just a very simple RPC protocol.

The PIO aspect of PCI is simple, yes, except on architectures that don't
have the concept of PIO or even uncached memory, but even that can
be done by defining readl/writel/inl/outl/... as hcalls.

The tricky part about PCI is the device probing, everything about config
space accesses, interrupt swizzling, bus/device/function numbers and
base address registers becomes a pointless excercise when the other side
is just faking it.

> DMA is trickier, as it makes the data appear into the address space of 
> the guest in a way that is both device- and host-dependent (in the 
> presence of PCI domains, IOMMU etc.)  There may be reason to avoid DMA 
> for that reason.

Right, PCI DMA and virtualization don't mix. DMA in general is fine though,
as long as your devices (real or virtual) see the guest physical addresses
as a contiguous 64 bit range and have well-defined semantics about what
addresses are accessed in what way.
When you think of file read/write syscalls as DMA into user space, it's
a very clean concept. Async I/O somewhat less so, but still pretty good.

	Arnd <><
