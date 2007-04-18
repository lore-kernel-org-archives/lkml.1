Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXDRIIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXDRIIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 04:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXDRIIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 04:08:45 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:57468 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012AbXDRIIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 04:08:44 -0400
Date: Wed, 18 Apr 2007 10:11:17 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070418101117.73edb302@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <4625169D.9020301@gmail.com>
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
	<20070417184110.GJ10619@htj.dyndns.org>
	<4625169D.9020301@gmail.com>
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

On Wed, 18 Apr 2007 03:49:01 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Oh, one more thing, with proper code audit, we can just make
> device_unregister() do the waiting instead of adding separate
> device_unregister_wait().  I think that will be a good step toward
> immediate-detach driver model.

Do we really want that? If the release function doesn't sit in the
module, or if the device_unregister() is done for other reasons in a
non-module, we don't care about lingering references. There's no need
to wait (and possibly lock up) there.
