Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXLDCqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXLDCqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 21:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbXLDCq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 21:46:27 -0500
Received: from mail.suse.de ([195.135.220.2]:39741 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXLDCq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 21:46:27 -0500
From: Neil Brown <neilb@suse.de>
To: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 4 Dec 2007 13:46:19 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18260.49019.684445.303719@notabene.brown>
Subject: Is BIO_RW_FAILFAST really usable?
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been looking at use BIO_RW_FAILFAST in md/raid to improve
handling of some error cases.

This is particularly significant for the DASD driver (s390 specific).
I believe it uses optic fibre to connect to the drives.  When one of
these paths is unplugged, IO requests will block until an operator
runs a command to reset the card (or until it is plugged back in).
The only way to avoid this blockage is to use BIO_RW_FAILFAST.  So
we really need BIO_RW_FAILFAST for a reliable RAID1 configuration on
DASD drives.

However, I just tested BIO_RW_FAILFAST on my SATA drives: controller 

02:06.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)

(not using the cards minimal RAID functionality) and requests fail
immediately and always with e.g.

sd 2:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sdc, sector 2048

So fail fast obviously isn't generally usable.

What is the answer here?  Is the Silicon Image driver doing the wrong
thing, or is DASD doing the wrong thing, or is BIO_RW_FAILFAST
under-specified and we really need multiple flags or what?

Any ideas?

Thanks,
NeilBrown
