Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXDKJWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXDKJWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXDKJWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:22:33 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:31202 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbXDKJWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:22:32 -0400
Date: Wed, 11 Apr 2007 11:24:53 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and
 etc.
Message-ID: <20070411112453.53167655@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070410151815.906ef9b4.akpm@linux-foundation.org>
References: <2375c9f90704010032r119f4a1eqb24dd611d5ecd943@mail.gmail.com>
	<20070402130128.707c8c19@gondolin.boeblingen.de.ibm.com>
	<20070405045410.GA4692@localhost.localdomain>
	<20070405111142.4723035f@gondolin.boeblingen.de.ibm.com>
	<20070405144409.GA5294@localhost.localdomain>
	<20070405170514.481b765f@gondolin.boeblingen.de.ibm.com>
	<20070405152732.GA5569@localhost.localdomain>
	<20070405180016.5099e0cd@gondolin.boeblingen.de.ibm.com>
	<20070406025343.GA2407@localhost.localdomain>
	<20070410143106.03d62e7c@gondolin.boeblingen.de.ibm.com>
	<20070410140829.GA3382@localhost.localdomain>
	<20070410151815.906ef9b4.akpm@linux-foundation.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 15:18:15 -0700,
Andrew Morton <akpm@linux-foundation.org> wrote:

> Note that I changed it to not send the KOBJ_REMOVE if we didn't send a
> KOBJ_ADD.

The whole part_uevent_suppress stuff is not really nice, causing the
code to use a lot of kobject_{init,add} and kobject_{del,put} instead
of kobject_register and kobject_unregister. Looking at
driver-class/block-device.patch in Greg's tree, it should be possible
to use something like the uevent_filter stuff after block has been
converted.
