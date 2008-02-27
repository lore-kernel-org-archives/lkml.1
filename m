Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYB0LsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYB0LsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYB0Lrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:47:52 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:21228 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbYB0Lrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:47:51 -0500
Date: Wed, 27 Feb 2008 12:47:48 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
Message-ID: <20080227124748.2e89e628@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0802271222530.5059@axis700.grange>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange>
	<20080220063834.GA22708@kroah.com>
	<Pine.LNX.4.64.0802251341160.4430@axis700.grange>
	<20080226201619.GA10343@kroah.com>
	<Pine.LNX.4.64.0802271222530.5059@axis700.grange>
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

On Wed, 27 Feb 2008 12:24:54 +0100 (CET),
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> Ok, result #1: kernel panic 
> http://home.arcor.de/g.liakhovetski/ap400/imga0045.jpg. If necessary, can 
> try a serial console, but that would be more difficult.

Looking at device_add(): Does the following patch make the oops go away?

---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/base/core.c
+++ linux-2.6/drivers/base/core.c
@@ -780,7 +780,7 @@ int device_add(struct device *dev)
 	dev = get_device(dev);
 	if (!dev || !strlen(dev->bus_id)) {
 		error = -EINVAL;
-		goto Error;
+		goto Done;
 	}
 
 	pr_debug("device: '%s': %s\n", dev->bus_id, __FUNCTION__);
