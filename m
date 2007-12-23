Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbXLWWcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbXLWWcF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 17:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbXLWWbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 17:31:55 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:52432 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbXLWWby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 17:31:54 -0500
Date: Mon, 24 Dec 2007 01:32:27 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Martin Mares <mj@ucw.cz>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a
	driver opt-in issue
Message-ID: <20071223223227.GA30643@jurassic.park.msu.ru>
References: <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <alpine.LFD.0.9999.0712222058160.21557@woody.linux-foundation.org> <1198444150.6686.17.camel@pasglop> <mj+md-20071223.211353.32429.nikam@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mj+md-20071223.211353.32429.nikam@ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 23, 2007 at 10:15:10PM +0100, Martin Mares wrote:
> >  - During that probe, you set a flag if any device has capabilities that
> > extend beyond 0xff.
> 
> Can this work?  The extended capabilities are not linked to the normal
> ones in any way.

Good point.

OTOH, we *do* have a flag for the extended capabilities - dev->cfg_size.
Obviously, the pci probe *without* mmconfig will set it to 256 for *all*
devices.
So Linus' idea of enabling mmconfig per-device makes a lot of sense in the
end - if mmconfig works, it just sets dev->cfg_size to 4096.
Without bloating the struct pci_dev or screwing up innocent arches...

Ivan.
