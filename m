Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXC1IXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXC1IXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934014AbXC1IXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:23:19 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:55291 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbXC1IXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:23:17 -0400
Date: Wed, 28 Mar 2007 10:25:12 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Eric Rannaud <eric.rannaud@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Larry Finger <larry.finger@lwfinger.net>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, Monakhov Dmitriy <dmonakhov@openvz.org>
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070328102512.56ecd00a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070328012635.GC18799@zenigma>
References: <4602752A.5050109@lwfinger.net>
	<20070322181019.62fe78ed@gondolin.boeblingen.de.ibm.com>
	<4602D137.4060402@lwfinger.net>
	<20070323111029.4089ccfb@gondolin.boeblingen.de.ibm.com>
	<20070323210618.6a41f5da.akpm@linux-foundation.org>
	<20070326110949.5301a571@gondolin.boeblingen.de.ibm.com>
	<20070326012232.0f0b9e09.akpm@linux-foundation.org>
	<20070326103432.GB18799@zenigma>
	<3ae72650703270225k1db9c4a8w6e31b95e007336d7@mail.gmail.com>
	<20070327191749.28298069@gondolin.boeblingen.de.ibm.com>
	<20070328012635.GC18799@zenigma>
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

On Wed, 28 Mar 2007 03:26:35 +0200,
Eric Rannaud <eric.rannaud@gmail.com> wrote:

> The reason for that original patch was that it is actually possible for the
> uevent functions to return -ENOMEM, the uevent buffer being statically
> allocated to BUFFER_SIZE (2048).

So maybe -ENOMEM should still be propagated? We just don't want to fail
device_add because of it.

> It used to be 1024 but that was not
> always enough and it was doubled a while ago [1]. Using add_uevent_var()
> makes this less of a problem as such an overflow should be catched
> cleanly [2].

Reminds me that I need to look into ccw_uevent :)
