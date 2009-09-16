Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbZIPO54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbZIPO54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 10:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZIPO5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 10:57:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZIPO5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 10:57:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Date: Wed, 16 Sep 2009 16:57:42 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
References: <20090914164750.GB3745@redhat.com> <4AAFFC8E.9010404@gmail.com> <20090915212545.GC27954@redhat.com>
In-Reply-To: <20090915212545.GC27954@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909161657.42628.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+LSOsXrTWwIyTfQH21eQUXR47pcAbNg2Zpm3j
 bdUPfIwUwZx757eTovKV3Z00F2fDQ5cc86UWDQBbxxzEa/h9Wb
 PrF15DxZzzEcTqY6UM0/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 September 2009, Michael S. Tsirkin wrote:
> Userspace in x86 maps a PCI region, uses it for communication with ppc?

This might have portability issues. On x86 it should work, but if the
host is powerpc or similar, you cannot reliably access PCI I/O memory
through copy_tofrom_user but have to use memcpy_toio/fromio or readl/writel
calls, which don't work on user pointers.

Specifically on powerpc, copy_from_user cannot access unaligned buffers
if they are on an I/O mapping.

	Arnd <><
