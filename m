Return-Path: <linux-kernel-owner+w=401wt.eu-S1760799AbXIYRDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799AbXIYRDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXIYRD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:03:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39837 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbXIYRDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:03:25 -0400
Date: Tue, 25 Sep 2007 19:03:24 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <gregkh@suse.de>
cc: Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.8, pata_ali issue
In-Reply-To: <20070925161430.GA14212@suse.de>
Message-ID: <Pine.LNX.4.64.0709251858520.945@fbirervta.pbzchgretzou.qr>
References: <20070925062115.GA18444@kroah.com>
 <6101e8c40709250909x53b44274i17694e64dccae427@mail.gmail.com>
 <20070925161430.GA14212@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>From my point, sorry for thread hijacking, but I did not have
the upper node anymore.

So, here is something that I think should go into the next 2.6.22.
A proper fix is already in 2.6.23-git-du-jour.

/home/build/rt.jengelh.10.2-i386/var/tmp/kernel-source-2.6.22.7-build
/usr/src/linux-2.6.22.7-13.1/drivers/ata/pata_ali.c:
In function ■ali_init_chipset■:

/home/build/rt.jengelh.10.2-i386/var/tmp/kernel-source-2.6.22.7-build
/usr/src/linux-2.6.22.7-13.1/drivers/ata/pata_ali.c:466:
warning: ■rev■ is used uninitialized in this function

Yes, it is indeed used uninitialized, and that is dangerous,
given that I do have a chipset that uses pata_ali.ko and
currently runs a 'broken' kernel...it has not exploded yet, though.

I could not backport and create a patch because struct pci_dev
does not have the ->revision field in 2.6.22 yet. Ideas?
