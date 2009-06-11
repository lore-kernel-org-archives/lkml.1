Return-Path: <linux-kernel-owner+w=401wt.eu-S1762012AbZFKDh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbZFKDh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758149AbZFKDhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:37:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60063 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZFKDhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:37:12 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Tony Breeds <tony@bakeyournoodle.com>, netdev@vger.kernel.org,
       michael@ellerman.id.au, Li Yang <leoli@freescale.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Nathan Lynch <ntl@pobox.com>
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>
Date: Thu, 11 Jun 2009 09:07:05 +0530
Message-Id: <20090611033705.20842.75501.sendpatchset@subratamodak.linux.ibm.com>
Subject: [PATCH][Resend 2][BUILD FAILURE 04/04] Next June 04:PPC64 randconfig [drivers/net/ucc_geth.o]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nathan,

>On Wed, 2009-06-10 at 21:28 -0500, Nathan Lynch wrote:
>Subrata Modak <subrata@linux.vnet.ibm.com> writes:
> 
> > On Thu, 2009-06-11 at 11:05 +1000, Stephen Rothwell wrote:
> >> Hi Subrata,
> >> 
> >> On Wed, 10 Jun 2009 23:13:23 +0530 Subrata Modak <subrata@linux.vnet.ibm.com> wrote:
> >> >
> >> >  	/* Find the TBI PHY.  If it's not there, we don't support SGMII */
> >> > -	ph = of_get_property(np, "tbi-handle", NULL);
> >> > +	ph = (phandle *)of_get_property(np, "tbi-handle", NULL);
> >> 
> >> You don't need this cast because of_get_property() returns "void *".
> >
> > Stephen,
> >
> > True. But without this gcc complains:
> >
> > CC [M]  drivers/net/ucc_geth.o
> > drivers/net/ucc_geth.c: In function ‘ucc_geth_probe’:
> > drivers/net/ucc_geth.c:3824: warning: assignment discards qualifiers
> > from pointer target type
> 
> ph should be declared const phandle *.  Look at other uses of
> of_get_property.
>

Ok fine. Here is a revised patch again.

Subject: [PATCH][Resend 2][BUILD FAILURE 04/04] Next June 04:PPC64 randconfig [drivers/net/ucc_geth.o]
Reference(s):
http://lkml.org/lkml/2009/6/4/241,
http://lkml.org/lkml/2009/6/10/338,

Fix the following build error:

drivers/net/ucc_geth.c: In function bucc_geth_probeb:
drivers/net/ucc_geth.c:3822: error: 'ph' undeclared (first use in this function)
drivers/net/ucc_geth.c:3822: error: (Each undeclared identifier is reported only once
drivers/net/ucc_geth.c:3822: error: for each function it appears in.)
drivers/net/ucc_geth.c:3832: error: 'mdio' undeclared (first use in this function)
make[2]: *** [drivers/net/ucc_geth.o] Error 1

Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
---

--- linux-2.6.30-rc8/drivers/net/ucc_geth.c.orig	2009-06-10 11:58:39.000000000 -0500
+++ linux-2.6.30-rc8/drivers/net/ucc_geth.c	2009-06-10 22:28:13.000000000 -0500
@@ -3595,6 +3595,8 @@ static const struct net_device_ops ucc_g
 
 static int ucc_geth_probe(struct of_device* ofdev, const struct of_device_id *match)
 {
+	struct device_node *mdio;
+	const phandle *ph;
 	struct device *device = &ofdev->dev;
 	struct device_node *np = ofdev->node;
 	struct net_device *dev = NULL;

---
Regards--
Subrata

