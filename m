Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZHMO6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZHMO6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZHMO6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:58:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbZHMO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:58:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Date: Thu, 13 Aug 2009 16:58:06 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1249930169.git.mst@redhat.com> <200908131538.44465.arnd@arndb.de> <20090813143922.GA5080@redhat.com>
In-Reply-To: <20090813143922.GA5080@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908131658.06522.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19CXqlnNEqaeNjxjQVdEVR+6uxE9gUtOkx+MKQ
 Gv3bpmYvHPLh2Yifa76twPrdeNZrJOjKOHZ+NKMiDMQzr07PjV
 MRRKTp0RKJ605RIK/qFyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Michael S. Tsirkin wrote:
> > Right now, the number of copy operations in your code is the same.
> > You are doing the copy a little bit later in skb_copy_datagram_iovec(),
> > which is indeed a very nice hack. Changing to a virtqueue based method
> > would imply that the host needs to add each skb_frag_t to its outbound
> > virtqueue, which then gets copied into the guests inbound virtqueue.
> 
> Which is a lot more code than just calling skb_copy_datagram_iovec.

Well, I don't see this part as much of a problem, because the code
already exists in virtio_net. If we really wanted to go down that road,
just using virtio_net would solve the problem of frame handling
entirely, but create new problems elsewhere, as we have mentioned.

	Arnd <><
