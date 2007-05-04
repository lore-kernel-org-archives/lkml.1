Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXEDLVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXEDLVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbXEDLVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:21:49 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:42455 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbXEDLVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:21:48 -0400
Message-ID: <463B1716.60108@s5r6.in-berlin.de>
Date: Fri, 04 May 2007 13:20:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, Kristian H??gsberg <krh@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       jejb@steeleye.com
Subject: Re: [PATCH 5/6] firewire: SBP-2 highlevel driver
References: <4637A29F.6070302@redhat.com> <20070502090007.GA28174@infradead.org> <tkrat.087ee29add656926@s5r6.in-berlin.de> <tkrat.350cb4dfe522266e@s5r6.in-berlin.de> <tkrat.65aea95f1451c211@s5r6.in-berlin.de> <tkrat.2aa3f3ac11a3d60d@s5r6.in-berlin.de> <tkrat.a41f7f10d21d3cc4@s5r6.in-berlin.de> <tkrat.c82a1d775d989371@s5r6.in-berlin.de> <20070502194408.GD1248@infradead.org> <4639085A.8010504@s5r6.in-berlin.de> <20070504095310.GB31811@infradead.org>
In-Reply-To: <20070504095310.GB31811@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>> >> +	sd->scsi_host->hostdata[0] = (unsigned long)unit;
...
> scsi_host_alloc
> is designed to allocate space for your private data aswell.  So you
> should call it early on an allocate the sbp2_device as part of the Scsi_Host
> instead of just stuffing in a pointer.

Aha, OK.

As long as we have 1 SBP-2 target LU == 1 instance of struct Scsi_Host,
the usage of ->hostdata as backpointer to an fw_unit is appropriate
though.  The lifetime of the fw_unit starts before and ends after that
of the Scsi_Host.  Of course if we reorganize this to use Scsi_Host more
as a representation of an SBP-2 initiator port (or for all our initiator
ports at once), some oddities like this ->hostdata usage will go away.

>> > The discovery of LUs of SBP-2 targets happens on the IEEE 1212
>> > level of things.
[...]
> Okay, so sbp2 decided to be non-standard here, what a pity.

Well, SBP-2 (the spec) is from the earlier days when the SCSI
Architecture Model was young and there didn't exist that many other SCSI
transports/interconnects besides SCSI Parallel Interconnect.  And for
better or worse, SBP-3 inherited this part of SBP-2's specialties.

> It's probably better to use scsi_scan_target with a specific lun,
> though as scsi_add_device is a rather awkward API.

Looking into these things were on my long-term agenda for mainline's
sbp2 driver anyway.  My plans just got dragged out when I expanded my
activities from ieee1394/sbp2 to ieee1394/.  As far as fw-sbp2 is
concerned, I don't know if these issues (which it merely took over from
sbp2) need to be addressed before integration into mainline.  fw-sbp2 is
something in the middle between a new submission and a gradual update.

Do you see the TODOs related to integration with the SCSI stack (which
apply to sbp2 as well) as blocking for fw-sbp2?

Thanks for looking into it and for all the advice,
-- 
Stefan Richter
-=====-=-=== -=-= --=--
http://arcgraph.de/sr/
