Return-Path: <linux-kernel-owner+w=401wt.eu-S1422716AbXDRJcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbXDRJcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422721AbXDRJcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:32:33 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:52637 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422716AbXDRJcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:32:32 -0400
Date: Wed, 18 Apr 2007 11:35:06 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg K-H <greg@kroah.com>,
       Rusty Russell <rusty@rustcorp.com.au>, dmitry.torokhov@gmail.com
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070418113506.06df2d21@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <4625DAD1.2070000@gmail.com>
References: <20070416193619.4659a847@gondolin.boeblingen.de.ibm.com>
	<20070417184110.GJ10619@htj.dyndns.org>
	<4625169D.9020301@gmail.com>
	<20070418101117.73edb302@gondolin.boeblingen.de.ibm.com>
	<4625DAD1.2070000@gmail.com>
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

On Wed, 18 Apr 2007 17:46:09 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> It's debatable but I think things will be safer this way.  If we wait by
> default, we are forced to check that all references are dropped and will
> have a stack dump indicating which object is causing problem when
> something goes wrong, which is better than silent object leaking and/or
> jumping to non-existent address way later.

I agree that oopsing is bad. However, lingering references are not
always coding errors. What if it will just take long for a reference to
be given up? You'd have a hanging device_unregister(), with no
particular gain.

> 
> I personally think all driver interface should be made this way such
> that completion of unregister function guarantees no further access to
> the object or module.  IMHO, it's more intuitive and easier to force
> correctness.

If we really did this, we should also provide a non-waiting alternative.

