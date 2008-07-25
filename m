Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbYGYEap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbYGYEap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 00:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYGYEah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 00:30:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:44278 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbYGYEag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 00:30:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=aeQZDasqnQSasiElOkM9ulz8O9oMQgIoJwRXL9bOuNeZNd416aI9V2u5+KqP1G7bAp
         47AOcvu7r9fNVncIk0nEnkwZVmLfRtUHyGGzIUk5WIp3O/CWMQwyytoCAt1S9C7LRMXv
         A/KpRuk5X/MofbTsHAZRFIXRVMJFlwT1NOYFk=
Message-ID: <fd145f7d0807242130p602610b0qc57ef4cf32c9ffa@mail.gmail.com>
Date: Thu, 24 Jul 2008 21:30:35 -0700
From: "Jeffrey Baker" <jwbaker@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 + ICH8M + high SATA load == death
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.24 with a SATA controller: Intel Corporation 82801HBM/HEM
(ICH8M/ICH8M-E) SATA AHCI Controller (rev 03) and a   Vendor: ATA
Model: SAMSUNG MCBQE32G Rev: PS10 flash disk, I get this error when
doing 32 parallel runs of pgbench:

ata1.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 action 0xa frozen
ata1.00: irq_stat 0x00400001, PHY RDY changed
ata1: SError: { PHYRdyChg CommWake }
ata1.00: cmd c8/00:10:67:38:97/00:00:00:00:00/e1 tag 0 dma 8192 in
         res 50/00:00:76:38:97/00:00:00:00:00/e1 Emask 0x10 (ATA bus error)
ata1.00: status: { DRDY }

Afterwards the machine was in some kind of bad state where it would do
only about 1MB/s to the disk, and I had to power it off.

Basically I have no idea what any of that gibberish means.  Note that
this device is about 80 times faster than the spinning disk it
replaced, so it may be stressing parts of the software that are not
normally stressed.  Note also that it could just be crap hardware.  I
don't really know.  However, I do note that someone recently posted a
very similar error using Western Digital disks and the same SATA
controller.  I don't think the problem is cables, since this is a
laptop.  Any advice welcome.

-jwb
