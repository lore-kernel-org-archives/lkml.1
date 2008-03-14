Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYCNEPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYCNEPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 00:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYCNEPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 00:15:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:42346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYCNEPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 00:15:05 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Date: Fri, 14 Mar 2008 00:13:58 -0400
User-Agent: KMail/1.9.9
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       Pierre Ossman <drzeus-list@drzeus.cx>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080313081048.GB19808@elf.ucw.cz> <20080313104217.GH2522@one.firstfloor.org>
In-Reply-To: <20080313104217.GH2522@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803140013.59146.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008, Andi Kleen wrote:
> On Thu, Mar 13, 2008 at 09:10:48AM +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > > > USB keeps processor out of C3 in many cases.
> > > > 
> > > > I figured that was the case. But I did not see any difference in powertop.
> > > 
> > > Modern Intel mobile processors have a feature called "C2 popup"
> > > that allows the processor to retire DMA from C3 without
> > > breaking into C0.  Instead the processor pops up to C2
> > > where the cache snoop can allow the DMA to retire --
> > > then it returns to C3, all transparent to software.
> > 
> > Does that mean we should go to C3 on modern intels, even with
> > busmaster going on, so that cpu can keep going C2..C3..C2 as needed?

That decision has already been made for us.
BM_STS has been made a no-op on recent processors.
It reports bus activity only for a small sub-set of
south-bridge devices.  Otherwise it tells us there
is none and that we should proceed into C3.

> C3 is still more expensive power wise to enter, so entering C3 just
> to let it immediately go back to C2 for bus mastering would be likely
> still a loss over staying at C2.

The newer the processor, the less exposed we area to this scenario.

cheers,
-Len
