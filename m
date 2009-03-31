Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbZCaJ1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbZCaJ1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZCaJ1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:27:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33285 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbZCaJ13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:27:29 -0400
From: Neil Brown <neilb@suse.de>
To: Rik van Riel <riel@redhat.com>
Date: Tue, 31 Mar 2009 20:27:20 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18897.57848.315067.51672@notabene.brown>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: message from Rik van Riel on Monday March 30
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	<49CD7B10.7010601@garzik.org>
	<49CD891A.7030103@rtr.ca>
	<49CD9047.4060500@garzik.org>
	<49CE2633.2000903@s5r6.in-berlin.de>
	<49CE3186.8090903@garzik.org>
	<49CE35AE.1080702@s5r6.in-berlin.de>
	<49CE3F74.6090103@rtr.ca>
	<20090329231451.GR26138@disturbed>
	<20090330003948.GA13356@mit.edu>
	<49D0710A.1030805@ursus.ath.cx>
	<20090330100546.51907bd2@the-village.bc.nu>
	<49D0A3D6.4000300@ursus.ath.cx>
	<49D0AA4A.6020308@redhat.com>
	<alpine.LFD.2.00.0903300817400.3948@localhost.localdomain>
	<49D0EF1E.9040806@redhat.com>
	<alpine.LFD.2.00.0903300922231.3948@localhost.localdomain>
	<49D0FD4C.1010007@redhat.com>
	<alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
	<49D11BDD.70702@redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday March 30, riel@redhat.com wrote:
> Linus Torvalds wrote:
> > On Mon, 30 Mar 2009, Ric Wheeler wrote:
> 
> >> Heat is a major killer of spinning drives (as is severe cold). A lot of times,
> >> drives that have read errors only (not failed writes) might be fully
> >> recoverable if you can re-write that injured sector.
> > 
> > It's not worked for me, and yes, I've tried.
> 
> It's worked here.  It would be nice to have a device mapper module
> that can just insert itself between the disk and the higher device
> mapper layer and "scrub" the disk, fetching unreadable sectors from
> the other RAID copy where required.

You want to start using 'md' :-)
With raid0,1,4,5,6,10, if it gets a read error, it find the data from
elsewhere and tries to over-write the read error and then read back.
If that all works, then it assume the drive is still good.
This happens during normal IO and all when you 'scrub' the array which
e.g. Debian does on the first Sunday of the month by default.

NeilBrown
