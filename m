Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYCJLHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYCJLHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbYCJLHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:07:30 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47594 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYCJLH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:07:29 -0400
Date: Mon, 10 Mar 2008 11:00:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080310100008.GA9520@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080303231033.GB15255@one.firstfloor.org> <20080304040048.GA31562@codemonkey.org.uk> <20080304071423.0e6b71c1@mjolnir.drzeus.cx> <20080304181924.70aaf8c1@mjolnir.drzeus.cx> <924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com> <20080305070201.0d16cd40@mjolnir.drzeus.cx> <20080305094023.6486ebdf@mjolnir.drzeus.cx> <20080306092730.4412d085@mjolnir.drzeus.cx> <20080309151659.63d54f38@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309151659.63d54f38@mjolnir.drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-03-09 15:16:59, Pierre Ossman wrote:
> I'm beginning to think this is a lost cause. I've tried several variants, all without satisfactory results.
> 
> In case anyone else has any more ideas, I'll detail what I've found influences the noise:
> 
> 1. C state
> 
> This is the big one. There is no noise as long as C3 is avoided (processor.max_cstate).
> 
> 2. uhci_hcd driver
> 
> USB is somehow involved in this problem. Unloading the uhci_hcd driver almost entirely kills the noise on a 1000 HZ NO_HZ kernel. On a 100 HZ, no NO_HZ kernel, the effect is very small, but still there.

USB keeps processor out of C3 in many cases.

> 4. Battery and AC
> 
> The noise increases with the battery present and also when the AC supply is removed.
>

On battery, some machines swap C3 for "secret" C4, which is slower but
saves power.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
