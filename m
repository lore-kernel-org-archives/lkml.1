Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYIDFB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYIDFB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 01:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbYIDFBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 01:01:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:51678 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbYIDFBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 01:01:17 -0400
From: Neil Brown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 4 Sep 2008 15:01:02 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18623.27534.745183.683281@notabene.brown>
Cc: thunder7@xs4all.nl,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #11441] lots of 'in_atomic():1, irqs_disabled():0' with software-raid1
In-Reply-To: message from Rafael J. Wysocki on Wednesday September 3
References: <q6jBvyFdWbL.A.K4C.fhbuIB@albercik>
	<N8SeMoDzuxC.A.IxD._hbuIB@albercik>
	<20080903194417.GA4937@amd64.of.nowhere>
	<200809032200.36471.rjw@sisk.pl>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday September 3, rjw@sisk.pl wrote:
> > > Patch		: http://marc.info/?l=linux-kernel&m=121998896602338&w=4
> > > 
> > As a matter of fact, now it's even worse.
> > 
> > On bootup, I see
> > 
> > md4: bitmap initalized from disk: read 10/10 pages, set 6 bits
> > created bitmap for device md4 (156 pages)
> > unable to handle null pointer dereference
> > write_page+0x179
> > 
> > _spin_unlock_irqrestore
> > bitmap_update_sb
> > bitmap_create
> > do_md_run
> > [ snipped the rest ]
> > 
> > when I boot 2.6.27-rc5 with the mentioned patch. I've written this
> > information down by hand. I don't have a dmesg, since my root filesystem
> > is on a raid1-volume, and thus I can't boot 2.6.27-rc5.
> > If you need more information, please let me know.

Yes.  As I said it was an untested patch and it did turn out to have a
problem when I finally found time to test it.
The fixed version is here:
 http://neil.brown.name/git?p=md;a=commitdiff;h=b2d2c4ceaddc3098f19637a732f74b820a81a9e7

and is with Linus now, so...
> 
> Can you test the current -git kernel, please?

...this is good advice.

Thanks,
NeilBrown
