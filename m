Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbXLDJPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbXLDJPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 04:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751107AbXLDJPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 04:15:43 -0500
Received: from brick.kernel.dk ([87.55.233.238]:22516 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbXLDJPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:15:43 -0500
Date: Tue, 4 Dec 2007 10:13:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Is BIO_RW_FAILFAST really usable?
Message-ID: <20071204091334.GG23294@kernel.dk>
References: <18260.49019.684445.303719@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18260.49019.684445.303719@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04 2007, Neil Brown wrote:
> 
> I've been looking at use BIO_RW_FAILFAST in md/raid to improve
> handling of some error cases.
> 
> This is particularly significant for the DASD driver (s390 specific).
> I believe it uses optic fibre to connect to the drives.  When one of
> these paths is unplugged, IO requests will block until an operator
> runs a command to reset the card (or until it is plugged back in).
> The only way to avoid this blockage is to use BIO_RW_FAILFAST.  So
> we really need BIO_RW_FAILFAST for a reliable RAID1 configuration on
> DASD drives.
> 
> However, I just tested BIO_RW_FAILFAST on my SATA drives: controller 
> 
> 02:06.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
> 
> (not using the cards minimal RAID functionality) and requests fail
> immediately and always with e.g.
> 
> sd 2:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
> end_request: I/O error, dev sdc, sector 2048
> 
> So fail fast obviously isn't generally usable.
> 
> What is the answer here?  Is the Silicon Image driver doing the wrong
> thing, or is DASD doing the wrong thing, or is BIO_RW_FAILFAST
> under-specified and we really need multiple flags or what?

Hrmpf. It looks like the SCSI layer is a little too trigger happy. Any
chance you could try and trace where this happens?

-- 
Jens Axboe

