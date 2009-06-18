Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZFRSro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZFRSro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbZFRSre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:47:34 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4949 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbZFRSrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:47:33 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH -next] bnx2i/cnic: kconfig interactions
From: "Michael Chan" <mchan@broadcom.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Anil Veerabhadrappa" <anilgv@broadcom.com>,
       scsi <linux-scsi@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@HansenPartnership.com>
In-Reply-To: <4A3A7175.8080006@oracle.com>
References: <20090618145949.d933719a.sfr@canb.auug.org.au>
 <4A3A7175.8080006@oracle.com>
Date: Thu, 18 Jun 2009 11:39:21 -0700
Message-ID: <1245350361.12000.219.camel@nseg_linux_HP1.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 6624544A0YS13234161-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2009-06-18 at 09:55 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> NETDEVICES + NETDEV_1000 need to be enabled so that kconfig will check
> those branches for selects and enforce "select UIO" under CNIC.
> Otherwise the build fails with:

I think this patch is better than your previous patch to select UIO.
Other iSCSI drivers that select net drivers will probably need something
similar too.

Thanks.
Acked-by: Michael Chan <mchan@broadcom.com>

> 
> ERROR: "uio_unregister_device" [drivers/net/cnic.ko] undefined!
> ERROR: "uio_event_notify" [drivers/net/cnic.ko] undefined!
> ERROR: "__uio_register_device" [drivers/net/cnic.ko] undefined!
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
> Cc: Michael Chan <mchan@broadcom.com>
> ---
>  drivers/scsi/bnx2i/Kconfig |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- linux-next-20090618.orig/drivers/scsi/bnx2i/Kconfig
> +++ linux-next-20090618/drivers/scsi/bnx2i/Kconfig
> @@ -1,6 +1,8 @@
>  config SCSI_BNX2_ISCSI
>  	tristate "Broadcom NetXtreme II iSCSI support"
>  	select SCSI_ISCSI_ATTRS
> +	select NETDEVICES
> +	select NETDEV_1000
>  	select CNIC
>  	depends on PCI
>  	---help---
> 
> 
> 


