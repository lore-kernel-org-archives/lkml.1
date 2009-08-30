Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbZH3OMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbZH3OMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 10:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZH3OMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 10:12:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58853 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753721AbZH3OM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 10:12:29 -0400
Date: Sun, 30 Aug 2009 15:13:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata_piix: parallel scanning on PATA needs an extra
 locking
Message-ID: <20090830151321.57bc33eb@lxorguk.ukuu.org.uk>
In-Reply-To: <200908301456.30132.bzolnier@gmail.com>
References: <200908301456.30132.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lets fix all such races by adding an extra locking to ->set_piomode
> and ->set_dmamode methods for PATA controllers.

Would it not be better to take the host lock in libata-core for these
cases so that we fix all the adapters in one swoop. Even if we are doing
this lock taking in the controller specific code it seems the right lock
to use ?

Looks fine as a temproary quickfix tho
