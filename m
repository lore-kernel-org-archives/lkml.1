Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYKPGEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYKPGEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 01:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYKPGEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 01:04:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:41128 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbYKPGEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 01:04:37 -0500
Message-ID: <491FB7E2.2030105@kernel.org>
Date: Sun, 16 Nov 2008 15:04:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Linda Walsh <lkml@tlinx.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-ide@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: FYI: BUG in SATA Promise 300 TX4 (2.6.24 - 2.6.27-3) w/Linux
References: <491C9A4F.1020801@tlinx.org>
In-Reply-To: <491C9A4F.1020801@tlinx.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Nov 2008 06:04:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Mikael Pettersson)
Hello, Linda.

Linda Walsh wrote:
> FYI -- ever since I switched to using SATA, I've not had a stable kernel.
> Sys uptime went from near infinite (striking planned take downs), to less
> than a week consistently.  I'd been using the Promise 300 TX4 with 1-2
> Seagate drives.  (PDC40718, rev 02).
> 
> Finally an explicit problem regarding that controller under Linux, with it
> timing out a drive returning from suspend during 'SMART' operations, got a
> suggestions from the community (Tnx, Tejun Heo) to try a _cheaper_ but
> better featured Silicon Image controller (SiI 3124 Sata).

Yeah, I'm quite fond of the controller.  Except for the bandwidth
limit due to limited number of postable requests which shows up only
when multiple drives are attached to a single port via PMP, I can't
think of anything bad about it.

> Not only did it NOT have the SMART problem (that would hang the drive or
> machine), but my random hangs seem to have gone away.
> 
> My main server has been up nearly 21 days now on 2.6.27-3 SMP
> (vanilla-i386).
> 
> I'd had problems with the ranging in kernels going back to 2.6.24 or so
> when I had first tried adding SATA to the system.
> 
> So Tnx again to Tejun --
> 
> and NOTE: the card or driver (or both) for the Promise 300 TX4 isn't
> stable for production use -- and has a repeatable problem of timing out
> some drives before it can spin-up from standby (just the drive -- not the
> computer).  The error logically removes the drive from the system until
> the next boot (unplugging, and replugging in the SATA cable on the drive
> would hang the machine within 5 seconds of replugging in the cable).  Not
> an instant, hang as might indicated a HW upset plugging in cable, but a
> couple second delay after plugin -- before keyboard would lock up --
> pointing toward the software trying to re-add+initialize the drive.

Some promise controllers seem to suffer transmission problems when
combined with certain drives, which often show up as timeouts.  The
hardreset of sata_promise wasn't as robust as it should have been and
in some cases it wasn't able to recover a link after error condition
causing the system to lose drive after such events.  The hardreset
problem was fixed recently by Mikael Pettersson.  Can you please try
2.6.28-rc5 and see whether sata_promise still loses drives after
failures?

Mikael, I think the hardreset fix is worthy including into -stable.
It should be safe for -stable too, right?

Thanks.

-- 
tejun
