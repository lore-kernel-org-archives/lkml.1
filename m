Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYCMKk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYCMKk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYCMKkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:40:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38158 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYCMKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:40:14 -0400
Date: Thu, 13 Mar 2008 11:42:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Andi Kleen <andi@firstfloor.org>, Lee Revell <rlrevell@joe-job.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080313104217.GH2522@one.firstfloor.org>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080310100008.GA9520@elf.ucw.cz> <20080310134915.45ae7446@mjolnir.drzeus.cx> <200803121511.17389.lenb@kernel.org> <20080313081048.GB19808@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313081048.GB19808@elf.ucw.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 09:10:48AM +0100, Pavel Machek wrote:
> Hi!
> 
> > > > USB keeps processor out of C3 in many cases.
> > > 
> > > I figured that was the case. But I did not see any difference in powertop.
> > 
> > Modern Intel mobile processors have a feature called "C2 popup"
> > that allows the processor to retire DMA from C3 without
> > breaking into C0.  Instead the processor pops up to C2
> > where the cache snoop can allow the DMA to retire --
> > then it returns to C3, all transparent to software.
> 
> Does that mean we should go to C3 on modern intels, even with
> busmaster going on, so that cpu can keep going C2..C3..C2 as needed?

C3 is still more expensive power wise to enter, so entering C3 just
to let it immediately go back to C2 for bus mastering would be likely
still a loss over staying at C2.

-Andi
