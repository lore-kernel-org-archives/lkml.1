Return-Path: <linux-kernel-owner+w=401wt.eu-S965612AbXBTALL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965612AbXBTALL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965607AbXBTALI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:11:08 -0500
Received: from paragon.brong.net ([66.232.154.163]:58776 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813AbXBTALA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:11:00 -0500
Date: Tue, 20 Feb 2007 11:10:50 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Sorin Faibish <sfaibish@emc.com>, Bill Davidsen <davidsen@tmr.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
Message-ID: <20070220001050.GA30206@brong.net>
References: <20070215200922.GB24643@lazybastard.org> <Pine.LNX.4.61.0702152353060.19998@ditec.inf.um.es> <20070216091321.GA28092@lazybastard.org> <45D642A4.5010009@tmr.com> <20070217151108.GA301@lazybastard.org> <45D7450F.6090309@tmr.com> <20070217183646.GE301@lazybastard.org> <op.tnwuonh3rwwil4@muki-1mj5c5mxes> <20070218055936.GF301@lazybastard.org> <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0702190625270.8828@ditec.inf.um.es>
Organization: brong.net
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 12:57:50AM +0100, Juan Piernas Canovas wrote:
> Now, let us assume that the data device takes 90% of the disk space, and 
> the meta-data device the other 10%. When the data device gets full, the 
> meta-data blocks will be using the half of the meta-data device, and the 
> other half (5% of the entire disk) will be free. Frankly, 5% is not too 
> much.

I'd like to very strongly second this.  We have a target maximum of 80%
usage on all partitions, with emailed warnings at 85% and paged warnings
at 90%.  I consider any partition over 90% to be dangerously over-full.
Given that disks space is approximately US$1/Gb in RAID6 SATA these
days, it doesn't cost much to make sure there's some free.

What matters a lot more is the speed at which you can get data on and
off these huge devices, because drive speed isn't keeping up with
capacity.  It takes about a week to fill one of the external storage
monsters we're buying these days, and that's streaming writes.  Makes
restoring from backup a scary proposition given the downtime it will
take.

But back on topic - I'd be very willing to pay a 5% disk space penalty
for the sort of performance that DualFS is promising, but I'd need a
2.6 series kernel with the O(1) scheduler or performance would go down
the toilet in the other direction.

Bron.

P.S. do you have any figures for high MMAP load?  We run big Cyrus, and
     it has a serious MMAP fetish.
