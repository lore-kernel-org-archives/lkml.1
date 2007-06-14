Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbXFNRdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbXFNRdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbXFNRdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:33:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47656 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXFNRdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:33:24 -0400
Message-ID: <46717BE2.3000703@garzik.org>
Date: Thu, 14 Jun 2007 13:33:22 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Nigel Kukard <nkukard@lbsd.net>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA problems
References: <8vX5T-4hg-5@gated-at.bofh.it> <8w0n1-15u-27@gated-at.bofh.it> <467173C4.1050500@lbsd.net>
In-Reply-To: <467173C4.1050500@lbsd.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Kukard wrote:
>>> I'm stumped trying to track down the below intermittent problem.....
>>>
>>> I've confirmed this problem on 2.6.19, 2.6.20 and 2.6.21.

>>> Jun 14 07:55:52 nigel-m2v kernel: ata2.00: exception Emask 0x0 SAct 0x0
>>> SErr 0x0 action 0x2 frozen
>>> Jun 14 07:55:52 nigel-m2v kernel: ata2.00: cmd
>>> ca/00:18:87:e7:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 12288 out
>>> Jun 14 07:55:52 nigel-m2v kernel:          res
>>> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>> Jun 14 07:55:52 nigel-m2v kernel: ata2: soft resetting port
>>> Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
>>> 0x0001c807
>>> Jun 14 07:55:52 nigel-m2v kernel: ATA: abnormal status 0x7F on port
>>> 0x0001c807
>>> Jun 14 07:56:22 nigel-m2v kernel: ata2.00: qc timeout (cmd 0xef)
>>> Jun 14 07:56:22 nigel-m2v kernel: ata2.00: failed to set xfermode
>>> (err_mask=0x4)

>> Try 2.6.22-rc4-gitX...

> Is there a patch in particular I can maybe apply? I see you made a
> couple of commits ... my problem is this is also happening on one of my
> production boxes which has a few other patches applied, I'm a bit scared
> of conflicts ... I don't really want to break anything by upgrading the
> kernel.

The two most relevant git commits:

commit 51b94d2a5a90d4800e74d7348bcde098a28f4fb3
Author: Tejun Heo <htejun@gmail.com>
Date:   Fri Jun 8 13:46:55 2007 -0700

     sata_promise: use TF interface for polling NODATA commands

commit 464cf177df7727efcc5506322fc5d0c8b896f545
Author: Tejun Heo <htejun@gmail.com>
Date:   Sun May 27 15:10:40 2007 +0200

     libata: always use polling SETXFER

If you have a git tree local to you, "git-diff-tree -p $COMMIT" will 
extract a patch, otherwise click "raw" after surfing to 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=$COMMIT

Regards,

	Jeff


