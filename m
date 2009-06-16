Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbZFPSFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbZFPSFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZFPSFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:05:00 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1133 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZFPSE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:04:59 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: [PATCH -next] bnx2i/cnic: more kconfig dependencies
From: "Michael Chan" <mchan@broadcom.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>
In-Reply-To: <4A37D599.5080701@oracle.com>
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
 <4A37D599.5080701@oracle.com>
Date: Tue, 16 Jun 2009 10:57:15 -0700
Message-ID: <1245175036.12000.70.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 662901353849372436-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-06-16 at 10:25 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> BNX2I selects CNIC, CNIC selects UIO.
> It looks like BNX2I also needs to select UIO.
> 

Yeah, it looks like if A selects B and B selects C, A does not
automatically select C, so we need to add it explicitly.

> BTW, CNIC is under NETDEV_1000, which is not enabled.
> I don't see any need to enable (select) it in this case,
> but I could be wrong(?).  Should BNX2I also select NETDEV_1000?

No that's not needed assuming we stay with using symbol_get() to resolve
a bnx2 driver symbol for now.

Thanks.

Acked-by: Michael Chan <mchan@broadcom.com>

> 
> cnic.c:(.text+0x17990b): undefined reference to `uio_event_notify'
> cnic.c:(.text+0x17a197): undefined reference to `uio_unregister_device'
> cnic.c:(.text+0x17c618): undefined reference to `__uio_register_device'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/scsi/bnx2i/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20090616.orig/drivers/scsi/bnx2i/Kconfig
> +++ linux-next-20090616/drivers/scsi/bnx2i/Kconfig
> @@ -2,6 +2,7 @@ config SCSI_BNX2_ISCSI
>  	tristate "Broadcom NetXtreme II iSCSI support"
>  	select SCSI_ISCSI_ATTRS
>  	select CNIC
> +	select UIO
>  	depends on PCI
>  	---help---
>  	This driver supports iSCSI offload for the Broadcom NetXtreme II
> 
> 


