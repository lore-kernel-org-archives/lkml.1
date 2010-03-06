Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0CFLJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 06:09:19 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61006 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab0CFLJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 06:09:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=uoHLkxSvDCnrmnVMPbsZNGn2t+ruVUgeQqzuEgrHhVc3MO5rptWkk+lo6XKhWKpd0p
         3AfDN1CLnv19xtlWqNx8w+7aevK4frRlfjOlE6td4WOQyWfTA4QBPJzadDdBxq2yctnD
         oqNuLeD3LS4BQIGPZj/90Ji78BvqWm0mNmwWc=
Date: Sat, 6 Mar 2010 14:08:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Matthias Kaehlcke <matthias@kaehlcke.net>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] goku_udc: potential null dereference
Message-ID: <20100306110856.GF4958@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Matthias Kaehlcke <matthias@kaehlcke.net>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	=?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"dev" is always null here.  In the end it's only used to get the 
pci_name() of "pdev" which is redundant information and so I
removed it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index e8edc64..1088d08 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -1768,7 +1768,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * usb_gadget_driver_{register,unregister}() must change.
 	 */
 	if (the_controller) {
-		WARNING(dev, "ignoring %s\n", pci_name(pdev));
+		pr_warning("ignoring %s\n", pci_name(pdev));
 		return -EBUSY;
 	}
 	if (!pdev->irq) {
