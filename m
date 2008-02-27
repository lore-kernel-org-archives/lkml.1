Return-Path: <linux-kernel-owner+w=401wt.eu-S1752636AbYB0NVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbYB0NVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYB0NVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:21:06 -0500
Received: from mtagate3.de.ibm.com ([195.212.29.152]:56379 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbYB0NVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:21:06 -0500
Date: Wed, 27 Feb 2008 14:21:03 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
Message-ID: <20080227142103.1dd42f8f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0802271328300.5059@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
	<20080220063834.GA22708@kroah.com>
	<Pine.LNX.4.64.0802251341160.4430@axis700.grange>
	<20080226201619.GA10343@kroah.com>
	<Pine.LNX.4.64.0802271222530.5059@axis700.grange>
	<20080227124748.2e89e628@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.64.0802271328300.5059@axis700.grange>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 13:33:13 +0100 (CET),
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> You mean the kernel panic without CONFIG_SYSFS_DEPRECATED? No, 
> unfortunately is doesn't.

Hm, dev->kobj.parent may be NULL in cleanup_device_parent(). Does this
one help?

---
 drivers/base/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -621,7 +621,8 @@ static struct kobject *get_device_parent
 static void cleanup_glue_dir(struct device *dev, struct kobject *glue_dir)
 {
 	/* see if we live in a "glue" directory */
-	if (!dev->class || glue_dir->kset != &dev->class->class_dirs)
+	if (!glue_dir || !dev->class ||
+	    glue_dir->kset != &dev->class->class_dirs)
 		return;
 
 	kobject_put(glue_dir);
