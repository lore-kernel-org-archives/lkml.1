Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbZHMOx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbZHMOx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZHMOx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:53:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbZHMOx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:53:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] vhost_net: a kernel-level virtio server
Date: Thu, 13 Aug 2009 16:53:46 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
References: <cover.1249930169.git.mst@redhat.com> <200908131548.35199.arnd@arndb.de> <20090813144129.GB5080@redhat.com>
In-Reply-To: <20090813144129.GB5080@redhat.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908131653.47029.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+wTWIIfCIT2jdjzJ2N+FAyncbzyl5NggA2/CV
 a7RY8h/yWYTkN231aHLtTTajkRpE6tcKj5E0jQNUE0rOWqyR2f
 do7QIcSSqFbKhhfl92uXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Michael S. Tsirkin wrote:
> The best way to do this IMO would be to add zero copy support to raw
> sockets, vhost will then get it basically for free.

Yes, that would be nice. I wonder if that could lead to security
problems on TX though. I guess It will only bring significant performance
improvements if we leave the data writable in the user space or guest
during the operation. If the user finds the right timing, it could
modify the frame headers after they have been checked using netfilter,
or while the frames are being consumed in the kernel (e.g. an NFS
server running in a guest).

	Ardn <><
