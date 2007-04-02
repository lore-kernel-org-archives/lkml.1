Return-Path: <linux-kernel-owner+w=401wt.eu-S1752336AbXDBPcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbXDBPcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXDBPcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:32:43 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:43500 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXDBPcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:32:41 -0400
Date: Mon, 2 Apr 2007 17:34:43 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, gregkh@suse.de,
       hugh@veritas.com, dmitry.torokhov@gmail.com, oneukum@suse.de,
       maneesh@in.ibm.com, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Message-ID: <20070402173443.0a3b5c51@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070402112048.047867c1@gondolin.boeblingen.de.ibm.com>
References: <460CDBA6.5030608@gmail.com>
	<1175257751.3760.19.camel@mulgrave.il.steeleye.com>
	<460D12B8.6050101@gmail.com>
	<1175278774.3760.44.camel@mulgrave.il.steeleye.com>
	<20070401195943.GA29627@htj.dyndns.org>
	<20070402112048.047867c1@gondolin.boeblingen.de.ibm.com>
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

On Mon, 2 Apr 2007 11:20:48 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> Cool. However, there's something fishy there (not sure whether it's in
> your patch or a latent bug in the ccw bus code that just has been
> uncovered):

Similar bug when loading/unloading a module that creates a driver
attribute. The winner seems to be kfree(sd->s_element) in
release_sysfs_dirent() (in case of an attribute, it will point to the
attribute structure, which is usually statically created)...
