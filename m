Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYFWAiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYFWAiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 20:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYFWAiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 20:38:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:52292 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbYFWAiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 20:38:08 -0400
Message-ID: <485EF061.3010601@kernel.org>
Date: Mon, 23 Jun 2008 09:37:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
       jgarzik@pobox.com, IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata_svw data corruption, strange problems
References: <20080617093602.GA28140@elf.ucw.cz>
In-Reply-To: <20080617093602.GA28140@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (hera.kernel.org [127.0.0.1]); Mon, 23 Jun 2008 00:38:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Pavel Machek wrote:
> I see strange problems on machine with sata_svw. The machine seems to
> corrupt data every few days (ext3 error, dir index corrupted), and has
> some other very strange problems (keyboard misbehaves, pulling out
> SATA disk cures it, see
> https://bugzilla.novell.com/show_bug.cgi?id=400772 ).
> 
> Then I got to the comment 
> 
>         writeb(dmactl | ATA_DMA_START, mmio + ATA_DMA_CMD);
>         /* There is a race condition in certain SATA controllers
> that can be seen when the r/w command is given to the controller
> before the host DMA is started. On a Read command, the controller
> would initiate the command to the drive even before it sees the DMA
> start. When there are very fast drives connected to the controller,
> or when the data request hits in the drive cache, there is the
> possibility that the drive returns a part or all of the requested
> data to the controller before the DMA start is issued.  In this
> case, the controller would become confused as to what to do with the
> data.  In the worst case when all the data is returned back to the
> controller, the controller could hang. In other cases it could
> return partial data returning in data corruption. This problem has
> been seen in PPC systems and can also appear on an system with very
> fast disks, where the SATA controller is sitting behind a number of
> bridges, and hence there is significant latency between the r/w
> command and the start command. */
>         /* issue r/w command if the access is to ATA*/
>         if (qc->tf.protocol == ATA_PROT_DMA)
> 
> ...and that would certainly explain what we are seeing. Are
> serverworks controllers broken by design?

The comment looks like a warning to me as the DMA engine is started
before the command is issued to the drive as explained in the next
comment.

-- 
tejun
