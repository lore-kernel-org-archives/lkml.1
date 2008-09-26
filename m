Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbYIZEwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbYIZEwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 00:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYIZEwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 00:52:14 -0400
Received: from smtp.nokia.com ([192.100.105.134]:39802 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYIZEwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 00:52:14 -0400
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kyungmin Park <kmpark@infradead.org>
Cc: apgmoorthy <moorthy.apg@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <9c9fda240809251731y48272a63j988e0001dc50d78@mail.gmail.com>
References: <19198934.52871221827459790.JavaMail.weblogic@epml16>
	 <9c9fda240809220011w49c0875q804f836550ff3476@mail.gmail.com>
	 <000001c91e42$1aa86c50$3dd66c6b@sisodomain.com>
	 <9c9fda240809251731y48272a63j988e0001dc50d78@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 26 Sep 2008 07:51:51 +0300
Message-Id: <1222404711.5012.5.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Sep 2008 04:51:55.0200 (UTC) FILETIME=[9974EC00:01C91F93]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-09-26 at 09:31 +0900, Kyungmin Park wrote:
> Hi,
> 
> A few comments
> 
> >
> > Signed-off-by: Vishak G <vishak.g@samsung.com>
> > Signed-off-by: Rohit Hagargundgi <h.rohit@samsung.com>
> 
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> > ---
> > diff -uprN a/drivers/mtd/onenand/onenand_base.c
> > b/drivers/mtd/onenand/onenand_base.c
> > --- a/drivers/mtd/onenand/onenand_base.c        2008-09-16
> > 20:48:12.000000000 +0530
> > +++ b/drivers/mtd/onenand/onenand_base.c        2008-09-24
> > 17:51:34.000000000 +0530
> > @@ -9,6 +9,10 @@
> >  *     auto-placement support, read-while load support, various fixes
> >  *     Copyright (C) Nokia Corporation, 2007
> >  *
> > + *     Vishak G <vishak.g@samsung.com>, Rohit Hagargundgi
> > <h.rohit@samsung.com>
> > + *     Flex-OneNAND support
> > + *     Copyright (C) Samsung Electronics, 2008
> > + *
> >  * This program is free software; you can redistribute it and/or modify
> >  * it under the terms of the GNU General Public License version 2 as
> >  * published by the Free Software Foundation.
> > @@ -27,6 +31,37 @@
> >
> >  #include <asm/io.h>
> >
> > +const static int boundary[] = {
> > +       FLEXONENAND_DIE0_BOUNDARY,
> > +       FLEXONENAND_DIE1_BOUNDARY,
> > +};
> > +
> > +const static int lock[] = {
> > +       FLEXONENAND_DIE0_ISLOCKED,
> > +       FLEXONENAND_DIE1_ISLOCKED,
> > +};
> > +
> 
> static const as others.
> 
> 
> > diff -uprN a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
> > --- a/include/mtd/mtd-abi.h     2008-09-16 20:48:12.000000000 +0530
> > +++ b/include/mtd/mtd-abi.h     2008-09-24 14:09:06.000000000 +0530
> > @@ -102,7 +102,11 @@ struct nand_oobinfo {
> >        uint32_t useecc;
> >        uint32_t eccbytes;
> >        uint32_t oobfree[8][2];
> > +#ifdef CONFIG_MTD_ONENAND
> > +       uint32_t eccpos[128];
> > +#else
> >        uint32_t eccpos[32];
> > +#endif
> >  };
> >
> >  struct nand_oobfree {
> > @@ -117,7 +121,11 @@ struct nand_oobfree {
> >  */
> >  struct nand_ecclayout {
> >        uint32_t eccbytes;
> > +#ifdef CONFIG_MTD_ONENAND
> > +       uint32_t eccpos[128];
> > +#else
> >        uint32_t eccpos[64];
> > +#endif
> >        uint32_t oobavail;
> >        struct nand_oobfree oobfree[MTD_MAX_OOBFREE_ENTRIES];
> >  };

I do not think stuff like this is going to be accepted because you
change ABI. You should instead introduce new ioctls or add sysfs
support and expose this information via sysfs. This is much bigger
work, but it is needed.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

