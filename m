Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbXJKTSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbXJKTSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 15:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbXJKTSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 15:18:45 -0400
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:42443 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539AbXJKTSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 15:18:44 -0400
X-Greylist: delayed 4142 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 15:18:44 EDT
Date: Thu, 11 Oct 2007 21:09:34 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       oprofile Mailing List <oprofile-list@lists.sourceforge.net>
Subject: Re: 2.6.22.6 + oprofile oops
Message-ID: <20071011180934.7texaggohmqmntra@m.safari.iki.fi>
Mail-Followup-To: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
	oprofile Mailing List <oprofile-list@lists.sourceforge.net>
References: <20070922112335.4wqatiewgeiottty@m.safari.iki.fi> <20070929170523.mepbfbdqwhnyrx3z@m.safari.iki.fi> <20071011143610.GA2881@zaniah>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071011143610.GA2881@zaniah>
User-Agent: Mutt/1.5.16 (2007-09-19)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 16:36:10 +0200, Philippe Elie wrote:
> On Sat, 29 Sep 2007 at 20:05 +0000, Sami Farin wrote:
> 
> > > x86_64 SMP kernel v2.6.22.6 (not using callgraph).
> > > sometimes oprofile works for a longer time... but not this time.
> > > 
> > > 2007-09-22 13:53:32.527237777 <1>[ 3372.390188] Unable to handle kernel NULL pointer dereference at 0000000000000650 RIP: 
> > > 2007-09-22 13:53:32.527245948 <1>[ 3372.390195]  [<ffffffff80652f44>] _spin_lock+0x4/0x20
> ...
> > 2007-09-22 13:53:32.527390314 <4>[ 3372.390457]  [<ffffffff80232b88>] get_task_mm+0x18/0x60
> 
> On the per cpu buffer writer side oprofile_add_sample() use profile_pc()
> to get the eip, profile_pc() can return ~0lu, but an eip == ~0lu is a
> magic value = ESCAPE_CODE. The per cpu reader side in buffer_sync.c use
> this value to know that the associated data is a task pointer but here
> the associated data is a counter number.

I applied this patch and I'm not able to reproduce Oops anymore
with 2.6.22.10 or 2.6.23.
Haven't gotten "oprofile: Invalid event", either.

Thanks a bunch!

-- 
Do what you love because life is too short for anything else.

