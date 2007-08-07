Return-Path: <linux-kernel-owner+w=401wt.eu-S934858AbXHGOiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858AbXHGOiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934744AbXHGOh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:37:59 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:24362 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764281AbXHGOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:37:56 -0400
Date: Tue, 7 Aug 2007 16:38:48 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Javier Pello <javier.pello@urjc.es>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not
 notified
Message-ID: <20070807163848.2ce04a9a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1186495705.3611.39.camel@lov.localdomain>
References: <46B37CF7.2020803@urjc.es>
	<20070806142451.5d28d41c@gondolin.boeb
 lingen.de.ibm.com>
	<46B7832B.6010808@urjc.es>
	<20070807125844.4d756b04@gondo
 l	in.boeblingen.de.ibm.com>
	<3ae72650708070446y6452d13jb7cd802119dab3ce@mail
 .gmail.com>
	<20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	<46B869C6.3090708@urjc.es>
	<1186491472.3611.33.camel@lov.localdomain>
	<46B87ACA.7010501@urjc.es>
	<1186495705.3611.39.camel@lov.localdomain>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 16:08:25 +0200,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> Nope, you would just fulfill in a completely generic way all outstanding
> requests when you are ready. All requests are all nicely grouped and
> visible in sysfs. There would be no need of coding your own device
> specific rebind. No timeout is needed or wanted, all requests would stay
> until userspace has handled them successfully or canceled them.

Hm, that would mean that no build-in driver may call
request_firmware(), only request_firmware_nowait() with no timeout.
Likely drivers that want to fail probe for no firmware will need to
split their probe functions.
