Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935801Ab0BZJt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 04:49:58 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46044 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935791Ab0BZJt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 04:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=IaCaynCp2qeu58CzmS06dWt4gBY1rTAJtRQtV2XiOpSIc8ncS5j2IJX/h7SzcibaTY
         k9W3DoxPL9wx/CvfgDDVfmxSymr69SXvse7mh8+2x+RR6HOX+7q5W4UXFQ5acOj9Q6Ts
         D3DVNPjbW6xz+sUKOpXfaY9iiJcFpbUYkthys=
Date: Fri, 26 Feb 2010 12:49:41 +0300
From: Dan Carpenter <error27@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: "David S. Miller" <davem@davemloft.net>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       Andy Fleming <afleming@freescale.com>,
       =?iso-8859-1?B?Suly9G1l?= Pouiller <jezz@sysmic.org>,
       devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [patch] of: check for IS_ERR()
Message-ID: <20100226094941.GE4912@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	"David S. Miller" <davem@davemloft.net>,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Andy Fleming <afleming@freescale.com>,
	=?iso-8859-1?B?Suly9G1l?= Pouiller <jezz@sysmic.org>,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_phy_device() can return an ERR_PTR()

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I don't have a cross compile environment set up so I can't even compile 
test this.  :/  But err.h is included so it should be OK.

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 18ecae4..b474833 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -69,7 +69,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 		}
 
 		phy = get_phy_device(mdio, be32_to_cpup(addr));
-		if (!phy) {
+		if (!phy || IS_ERR(phy)) {
 			dev_err(&mdio->dev, "error probing PHY at address %i\n",
 				*addr);
 			continue;
