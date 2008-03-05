Return-Path: <linux-kernel-owner+w=401wt.eu-S933598AbYCEMcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbYCEMcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759680AbYCEMcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:32:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44005 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785AbYCEMcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:32:20 -0500
Date: Wed, 5 Mar 2008 10:03:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080305090304.GA10053@elf.ucw.cz>
References: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com> <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080303231033.GB15255@one.firstfloor.org> <20080304040048.GA31562@codemonkey.org.uk> <20080304071423.0e6b71c1@mjolnir.drzeus.cx> <20080304181924.70aaf8c1@mjolnir.drzeus.cx> <924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com> <20080305070201.0d16cd40@mjolnir.drzeus.cx> <20080305094023.6486ebdf@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305094023.6486ebdf@mjolnir.drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-05 09:40:23, Pierre Ossman wrote:
> On Wed, 5 Mar 2008 07:02:01 +0100
> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> 
> > 
> > I tried using predicted_us and last_measured_us, and those didn't work (see the #if 0 code in my last patch). And since cpuidle_get_last_residency() is part of predicted_us, I don't think it is reporting useful values.
> > 
> 
> I take this back. They might be working just fine. It seems I've been looking at a too small piece of the puzzle. This machine has a dual core processor, and the governors control each core independently. Unfortunately it's the power fluctuations of the entire socket that causes noise, not just each processor.
> 
> So I need to build some global algorithm instead of one per core. Ideas are welcome.
> 
> From what I can tell, disabling one core makes the noise go away. So I guess both cores need to go into C3 (or perhaps one C2 and one C3) at the same time to cause the problem. I'm not 100% sure of this as the damn noise comes and goes, but I've been running for an hour or so now with one core disabled and without my anti-noise patch.
> 

Actually, there are more uncertaininties. Suspecting some machines
seemed to produce noise whenever they were in low-power state. Not
with fluctuations: when I forced them to low-power, it just produced
steady beep.

(Thinkpad 560X and toshiba 4030cdt, IIRC).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
