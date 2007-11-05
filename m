Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbXKEKdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbXKEKdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 05:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXKEKdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 05:33:36 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:13670 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbXKEKdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 05:33:35 -0500
Date: Mon, 5 Nov 2007 11:33:19 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 33/54] driver core: remove fields from struct bus_type
Message-ID: <20071105113319.4c54f711@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1194047972-9850-33-git-send-email-gregkh@suse.de>
References: <20071102235758.GA9803@kroah.com>
	<1194047972-9850-33-git-send-email-gregkh@suse.de>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2007 16:59:11 -0700,
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> struct bus_type is static everywhere in the kernel.  This moves the
> kobject in the structure out of it, and a bunch of other private only to
> the driver core fields are now moved to a private structure.  This lets
> us dynamically create the backing kobject properly and gives us the
> chance to be able to document to users exactly how to use the struct
> bus_type as there are no fields they can improperly access.
> 
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/base/base.h     |   30 +++++++++++-
>  drivers/base/bus.c      |  120 ++++++++++++++++++++++++++--------------------
>  drivers/base/core.c     |    6 +-
>  drivers/base/dd.c       |    4 +-
>  drivers/base/driver.c   |    2 +-
>  drivers/base/platform.c |    4 +-
>  include/linux/device.h  |   12 +----
>  7 files changed, 107 insertions(+), 71 deletions(-)
> 

drivers/base/bus.c: In function 'make_deprecated_bus_links':
drivers/base/bus.c:428: error: 'struct bus_type' has no member named 'subsys'

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 drivers/base/bus.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/base/bus.c
===================================================================
--- linux-2.6.orig/drivers/base/bus.c	2007-11-05 11:12:49.000000000 +0100
+++ linux-2.6/drivers/base/bus.c	2007-11-05 11:30:28.000000000 +0100
@@ -425,7 +425,7 @@ static void device_remove_attrs(struct b
 static int make_deprecated_bus_links(struct device *dev)
 {
 	return sysfs_create_link(&dev->kobj,
-				 &dev->bus->subsys.kobj, "bus");
+				 &dev->bus->p->subsys.kobj, "bus");
 }
 
 static void remove_deprecated_bus_links(struct device *dev)
