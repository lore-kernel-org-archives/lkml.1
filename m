Return-Path: <linux-kernel-owner+w=401wt.eu-S1755785AbYGSKXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785AbYGSKXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYGSKWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:22:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:51435 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599AbYGSKWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:22:23 -0400
Message-ID: <48809BA0.8060500@kernel.org>
Date: Fri, 18 Jul 2008 22:33:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: chunbo.luo@windriver.com
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]: libata-scsi: Don't start hotplug work queue if hotplug
 is	disabled
References: <1214533246.6284.10.camel@pek-cluo>
In-Reply-To: <1214533246.6284.10.camel@pek-cluo>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Jul 2008 10:21:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chunbo Luo wrote:
> Hi
> 
> When ata_scsi_scan_host() scan device failed, it will start a work queue
> unconditionally. This may cause some noisy messages. This patch fix this
> problem.

ATA_PFLAG_SCSI_HOTPLUG doesn't mean that hotplug is enabled.  It
indicates that EH needs to schedule a kick at SCSI's ass and make it
scan for discovered devices && work running on ata_aux_wq testing it
doesn't mean anything.  There's no synchronization.

>     Previously, queue_delayed_work() was started unconditionally, but if
>     ATA_PFLAG_SCSI_HOTPLUG is not set and we do this, the work queue may
>     cause multiple messages like this:
>     
>     ata3.00: WARNING: ATAPI is not supported with this driver, device ignored.

And this message has nothing to do with SCSI.  It's printed by libata
proper for several drivers which don't support ATAPI.  Did the patch
really kill the warning messages?  Can you please post full boot log
from 2.6.26 w/o the patch?

Andrew, please drop the patch from -mm.  Thanks.

-- 
tejun
