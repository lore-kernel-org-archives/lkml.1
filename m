Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbXC3NR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbXC3NR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXC3NR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:17:26 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:63382 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXC3NRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:17:24 -0400
Date: Fri, 30 Mar 2007 15:19:26 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, hugh@veritas.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, maneesh@in.ibm.com, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Message-ID: <20070330151926.18fc12a0@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <460CDBA6.5030608@gmail.com>
References: <460CDBA6.5030608@gmail.com>
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

On Fri, 30 Mar 2007 18:43:02 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> One way to solve this problem is to subordinate lifetime rule #b to
> rule #c.  Each kobject points to its owning module such that grabbing
> a kobject automatically grabs the module.  The problem with this
> approach is that it requires wide update and makes kobject_get
> heavier.

Shouldn't getting/putting the module refcount be solely done in
kobject.c? Grab the module reference when the kobject is created and
release the module reference in kobject_cleanup() after the release
function has been called. This doesn't make kobject_get() heavier, and
it ensures we don't delete the module until after the last kobject it is
supposed to clean up has been released.
