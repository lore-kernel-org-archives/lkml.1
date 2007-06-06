Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbXFFKkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbXFFKkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbXFFKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:40:37 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:38484 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759978AbXFFKkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:40:36 -0400
X-Greylist: delayed 1252 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2007 06:40:36 EDT
Message-ID: <46668A30.2040907@suse.de>
Date: Wed, 06 Jun 2007 19:19:28 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: David Greaves <david@dgreaves.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, xfs@oss.sgi.com,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       netdev@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>,
       Neil Brown <neilb@suse.de>, mikpe@it.uu.se
Subject: Re: [PATCH] sata_promise: use TF interface for polling NODATA commands
References: <46608E3F.4060201@dgreaves.com> <200706012342.45657.rjw@sisk.pl> <46609FAD.7010203@dgreaves.com> <200706020122.49989.rjw@sisk.pl> <4661EFBB.5010406@dgreaves.com> <alpine.LFD.0.98.0706021538360.23741@woody.linux-foundation.org> <4662D852.4000005@dgreaves.com> <46667160.80905@gmail.com> <20070606101837.GC29122@htj.dyndns.org>
In-Reply-To: <20070606101837.GC29122@htj.dyndns.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> sata_promise uses two different command modes - packet and TF.  Packet
> mode is intelligent low-overhead mode while TF is the same old
> taskfile interface.  As with other advanced interface (ahci/sil24),
> ATA_TFLAG_POLLING has no effect in packet mode.  However, PIO commands
> are issued using TF interface in polling mode, so pdc_interrupt()
> considers interrupts spurious if ATA_TFLAG_POLLING is set.
> 
> This is broken for polling NODATA commands because command is issued
> using packet mode but the interrupt handler ignores it due to
> ATA_TFLAG_POLLING.  Fix pdc_qc_issue_prot() such that ATA/ATAPI NODATA
> commands are issued using TF interface if ATA_TFLAG_POLLING is set.
> 
> This patch fixes detection failure introduced by polling SETXFERMODE.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>

Eeeek... Wrong thread.  Please ignore this posting.  Will repost.  Sorry.

-- 
tejun
