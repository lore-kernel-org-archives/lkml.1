Return-Path: <linux-kernel-owner+w=401wt.eu-S1764388AbXFAUSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764388AbXFAUSM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 16:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762382AbXFAUR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 16:17:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55425 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764166AbXFAUR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 16:17:56 -0400
Message-ID: <46607EEF.8080602@garzik.org>
Date: Fri, 01 Jun 2007 16:17:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Dave Dillow <dave@thedillows.org>, dean gaudet <dean@arctic.org>
Subject: Re: [PATCH] sata_mv: new exception handling (hotplug, NCQ framework)
References: <20070519054201.GA32686@havoc.gtf.org> <464EE3E9.80708@wpkg.org>
In-Reply-To: <464EE3E9.80708@wpkg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski wrote:
> Jeff Garzik schrieb:
>> Below is a refresh of my on-going effort to convert sata_mv to the new
>> exception handling framework.  sata_mv is one of the last hold-outs, and
>> its old-EH implementation blocks new features like hotplug and NCQ.
>>
>> It works for me on the one 50xx and one 60xx card I tested it on, but
>> other testers reported regressions, which is why it is not yet upstream.
> 
> Hi,
> 
> If I'm correct, this patch won't make to 2.6.22, and the first possible 
> inclusion would be 2.6.23?

Correct... if that.  No guarantee it will make 2.6.23 either, since it 
is low priority :(


> Could you summarize what other regressions were reported? I can't find 
> much information about sata_mv regressiobs on linux-ide list (at least 
> when looking at the subjects: lots of patches from you, and two reports 
> from me).

Dave Dillow and dean gaudet responded with reports that the 
BUG_ON/WARN_ON traps in would trigger:

WARNING: at drivers/ata/sata_mv.c:1287 mv_qc_issue()
	and
WARNING: at drivers/ata/sata_mv.c:1333 mv_get_crpb_status()

which leads me to think that my sata_mv new-EH patches are accidentally 
turning on NCQ mode.

I have a feeling that I will be able to reproduce this once I attach an 
NCQ-capable drive and re-test on my own systems, but again, haven't 
found the time :/

	Jeff


