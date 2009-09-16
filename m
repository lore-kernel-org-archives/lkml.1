Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbZIPPXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbZIPPXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759277AbZIPPXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:23:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60668 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271AbZIPPXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:23:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv5 3/3] vhost_net: a kernel-level virtio server
Date: Wed, 16 Sep 2009 17:22:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: Gregory Haskins <gregory.haskins@gmail.com>, Avi Kivity <avi@redhat.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com,
       Rusty Russell <rusty@rustcorp.com.au>, s.hetze@linux-ag.com,
       alacrityvm-devel@lists.sourceforge.net
References: <20090914164750.GB3745@redhat.com> <200909161657.42628.arnd@arndb.de> <20090916151329.GC5513@redhat.com>
In-Reply-To: <20090916151329.GC5513@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909161722.37606.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX183NgoHRjP+YMpSUMaf5FtblG94v60hZ/3Ypkh
 Ri9RT/XitRuOjEQbTeZxkBV/8TLJog+qnlu0nAzln0gSJI10zS
 da66O/5qGbUhklrhq8r3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 September 2009, Michael S. Tsirkin wrote:
> On Wed, Sep 16, 2009 at 04:57:42PM +0200, Arnd Bergmann wrote:
> > On Tuesday 15 September 2009, Michael S. Tsirkin wrote:
> > > Userspace in x86 maps a PCI region, uses it for communication with ppc?
> > 
> > This might have portability issues. On x86 it should work, but if the
> > host is powerpc or similar, you cannot reliably access PCI I/O memory
> > through copy_tofrom_user but have to use memcpy_toio/fromio or readl/writel
> > calls, which don't work on user pointers.
> > 
> > Specifically on powerpc, copy_from_user cannot access unaligned buffers
> > if they are on an I/O mapping.
> > 
> We are talking about doing this in userspace, not in kernel.

Ok, that's fine then. I thought the idea was to use the vhost_net driver
to access the user memory, which would be a really cute hack otherwise,
as you'd only need to provide the eventfds from a hardware specific
driver and could use the regular virtio_net on the other side.

	Arnd <><
