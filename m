Return-Path: <linux-kernel-owner+w=401wt.eu-S937879AbXHPDRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937879AbXHPDRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 23:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763496AbXHPDRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 23:17:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2348 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763024AbXHPDRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 23:17:14 -0400
Subject: Re: drivers/infiniband/mlx/mad.c misplaced ;
From: Joe Perches <joe@perches.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: netfilter-devel@lists.netfilter.org, coreteam@netfilter.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46C3B428.4000003@intel.com>
References: <20070815235825.GB17004@redhat.com>
	 <1187224811.5906.55.camel@localhost>  <46C3B428.4000003@intel.com>
Content-Type: text/plain
Date: Wed, 15 Aug 2007 20:17:05 -0700
Message-Id: <1187234225.5906.73.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-15 at 19:19 -0700, Kok, Auke wrote:
> Joe Perches wrote:
> > On Wed, 2007-08-15 at 19:58 -0400, Dave Jones wrote:
> > There's more than a few of these (not inspected).
> > $ egrep -r --include=*.c "\bif[[:space:]]*\([^\)]*\)[[:space:]]*\;" * 
> > arch/sh/boards/se/7343/io.c:    if (0) ;
> > drivers/atm/iphase.c:     if (!desc1) ;
> > drivers/infiniband/hw/mlx4/mad.c:       if (!err);
> > drivers/isdn/capi/capiutil.c:   else if (c <= 0x0f);
> > drivers/net/tokenring/ibmtr.c:  else if (ti->shared_ram_paging == 0xf);  /* No paging in adapter */
> > drivers/s390/scsi/zfcp_erp.c:           if (status == ZFCP_ERP_SUCCEEDED) ;     /* no further action */
> > fs/hostfs/hostfs_user.c:        if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;
> > net/netfilter/xt_u32.c:         if (skb->len < 4 || pos > skb->len - 4);
> > sound/pci/au88x0/au88x0_synth.c:                                if (eax == 0) ;
> 
> sounds like an excellent candidate check for checkpatch.pl !!!

I think it's poor style and all of these should go away.

the netfilter one appears to be a real error too.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 74f9b14..bec4279 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -36,7 +36,7 @@ static bool u32_match_it(const struct xt_u32 *data,
 		at  = 0;
 		pos = ct->location[0].number;
 
-		if (skb->len < 4 || pos > skb->len - 4);
+		if (skb->len < 4 || pos > skb->len - 4)
 			return false;
 
 		ret   = skb_copy_bits(skb, pos, &n, sizeof(n));


