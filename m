Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbXFUC5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbXFUC5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 22:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXFUC5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 22:57:00 -0400
Received: from ns2.suse.de ([195.135.220.15]:56293 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbXFUC47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 22:56:59 -0400
From: Neil Brown <neilb@suse.de>
To: David Chinner <dgc@sgi.com>
Date: Thu, 21 Jun 2007 12:56:44 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18041.59628.370832.633244@notabene.brown>
Cc: Avi Kivity <avi@argo.co.il>, david@lang.hm, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: message from David Chinner on Monday June 18
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<467273AB.9010202@argo.co.il>
	<18035.3009.568832.785308@notabene.brown>
	<20070618045759.GD85884050@sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday June 18, dgc@sgi.com wrote:
> On Sat, Jun 16, 2007 at 07:59:29AM +1000, Neil Brown wrote:
> > Combining these thoughts, it would make a lot of sense for the
> > filesystem to be able to say to the block device "That blocks looks
> > wrong - can you find me another copy to try?".  That is an example of
> > the sort of closer integration between filesystem and RAID that would
> > make sense.
> 
> I think that this would only be useful on devices that store
> discrete copies of the blocks on different devices i.e. mirrors. If
> it's an XOR based RAID, you don't have another copy you can
> retreive....

You could reconstruct the block in question from all the other blocks
(including parity) and see if that differs from the data block read
from disk...  For RAID6, there would be a number of different ways to
calculate alternate blocks.   Not convinced that it is actually
something we want to do, but it is a possibility.

I have that - apparently naive - idea that drives use strong checksum,
and will never return bad data, only good data or an error.  If this
isn't right, then it would really help to understand what the cause of
other failures are before working out how to handle them....

NeilBrown
