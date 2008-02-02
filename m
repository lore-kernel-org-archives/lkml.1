Return-Path: <linux-kernel-owner+w=401wt.eu-S1763081AbYBBOTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763081AbYBBOTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 09:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbYBBOTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 09:19:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44702 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888AbYBBOTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:19:08 -0500
Date: Sat, 2 Feb 2008 15:18:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [scsi bug] spurious build failures in aic7xxx
Message-ID: <20080202141857.GA8635@elte.hu>
References: <20080201225056.GA18302@elte.hu> <20080202135935.GA23838@uranus.ravnborg.org> <20080202140326.GA6544@elte.hu> <20080202140630.GA7939@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202140630.GA7939@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i should also specify the build environment:

it's a distcc setup with 5-10 hosts active at a time, so highly parallel 
with large, networking related delays. It's make -j130:

nice -15 /usr/bin/time make -j130 bzImage ARCH=i386 \
CROSS_COMPILE='distcc \
/opt/crosstool/gcc-4.2.2-glibc-2.3.6/i686-unknown-linux-gnu-'

the build host is a 64-bit quad CPU box, so highly parallel as well.

before this i did about a thousand x86.git builds/boots a day without 
any build (or boot) failure, so i'm 100% sure that the build race was 
not present before. It started triggering it a few days ago, roughly 
when the commit you suspected went in.

here's all SCSI build failures logged from the past 1-2 days:

      2 drivers/scsi/aic7xxx/aic79xx_reg.h
      4 drivers/scsi/aic7xxx/aic7xxx.h
      4 drivers/scsi/lpfc/lpfc_init.c
     12 drivers/scsi/aic7xxx/aic7xxx_osm.h
    108 drivers/scsi/aic7xxx/aic7xxx_inline.h
    280 drivers/scsi/aic7xxx/aic7xxx_pci.c

first column is the number of error lines from logs.

When i turned off all the AICxxxx builds (all 3 drivers for good 
measure), the build failures went away. [but this excludes one of my 
testboxes from qa coverage - which has aic7xxx hardware - so it would be 
nice to fix this.]

the host box is Fedora 8, make-3.81-10.fc8. gcc-4.2.2 crosscompiler, 
built from sources. (i.e. not distro patched)

	Ingo
