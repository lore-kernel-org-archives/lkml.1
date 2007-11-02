Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbXKBVDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbXKBVDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 17:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbXKBVCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 17:02:50 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4480 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760511AbXKBVCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 17:02:48 -0400
X-Server-Uuid: 20144BB6-FB76-4F11-80B6-E6B2900CA0D7
Subject: Re: expected behavior of PF_PACKET on NETIF_F_HW_VLAN_RX
 device?
From: "Michael Chan" <mchan@broadcom.com>
To: "Dave Johnson" <djohnson+linux-kernel@sw.starentnetworks.com>
cc: linux-kernel@vger.kernel.org, "netdev" <netdev@vger.kernel.org>,
       bguo@sw.starentnetworks.com
In-Reply-To: <18219.26528.485099.317944@zeus.sw.starentnetworks.com>
References: <20071031123359.3954befc@freepuppy.rosehill>
 <4729269A.6090606@candelatech.com>
 <47292A99.5070805@linux-foundation.org>
 <20071031.215025.195350296.davem@davemloft.net>
 <4729EAFF.9050606@candelatech.com>
 <18218.18134.353553.189622@zeus.sw.starentnetworks.com>
 <18219.26528.485099.317944@zeus.sw.starentnetworks.com>
Date: Fri, 02 Nov 2007 13:52:08 -0800
Message-ID: <1194040328.13340.18.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6B354FE54QC12940720-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 14:08 -0400, Dave Johnson wrote:

> > 
> > *2:  If chip supports 'ASF', tag is always stripped (see *1 above).
> >      Looks ok if ASF is not supported. 
> 
> Michael,
> 
> These changes seems to cause this issue:
> 
> >  [BNX2]: Fix VLAN on ASF
> >  
> >  Always set up the device to strip incoming VLAN tags when ASF is
> >  enabled. ASF firmware will not parse packets correctly if VLAN tags
> >  are not stripped.
> >  
> >  Signed-off-by: Michael Chan <mchan@broadcom.com>
> >  Signed-off-by: David S. Miller <davem@davemloft.net>
> >  
> >  GIT: e29054f92d7d575631691865c1b95bee5bc974cc
> 
> and
> 
> > ChangeSet@1.1371.72.2, 2003-12-02 02:34:13-08:00, davem@nuts.ninka.net +1 -0
> >   [TG3]: Do not set RX_MODE_KEEP_VLAN_TAG when ASF is enabled.
> 
> 
> Could you elaborate if this is really needed, if so is there some
> workaround that could be done instead?

This is needed for management firmware to work properly.  Management
firmware expects any VLAN tags to be stripped.  Unfortunately, VLAN
stripping cannot be done independently between the driver and the
firmware.  The workaround is to disable management firmware.

> 
> Simply removing the check seemed to work for me, but I'm unsure if
> this is actually a valid thing to do with these MACs.

Most of these on-board devices are shipped with management firmware
enabled.  Removing the check will make the firmware not functional.

We realize this VLAN limitation is causing problems to many users and we
are looking for ways to address it.

