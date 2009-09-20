Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZITSwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZITSwF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZITSwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:52:01 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63902 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755319AbZITSwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:52:01 -0400
To: linux-kernel@vger.kernel.org
CC: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Poor desktop responsiveness with background I/O-operations
References: <dmlhK-6ws-5@gated-at.bofh.it> <dmnMy-8tg-7@gated-at.bofh.it>
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Sun, 20 Sep 2009 14:51:47 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
Message-Id: <E1MpRVj-0000OA-G9@approx.mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> wrote:

> can you try the following two things?
>
> echo 4096 > /sys/block/sda/queue/nr_requests
> for i in `pidof kjournald` ; do ionice -c1 -p $i ; done
>
> to see if they help?

That helped here.  The hardware is a Thinkpad T60 with 1.5GB RAM and
this hard drive:

  ata1.00: ATA-7: Hitachi HTE541616J9SA00, SB4OC7KP, max UDMA/100
  ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)

When the 'locate' daily cron job runs, or I run 'aptitude
dist-upgrade' (after all packages are downloaded), or I back up /home
to a USB hard drive using rsync, the desktop response badly degrades.

I'm not using a fancy desktop---just twm.  An rxvt can take up to 10
seconds to start up, and I often see emacs repainting its window when it
comes to the foreground.  Using your settings, rxvt takes about 1 second
to start up, which is a large improvement.

(The kernel is 2.6.30 with debian patches)

-Sanjoy
