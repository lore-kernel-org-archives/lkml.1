Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYKPSIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYKPSIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 13:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbYKPSId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 13:08:33 -0500
Received: from 50.38.69.212.in-addr.fnarfbargle.com ([93.93.128.63]:38930 "EHLO
	fnarfbargle.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYKPSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 13:08:32 -0500
X-Greylist: delayed 2113 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Nov 2008 13:08:31 EST
Message-ID: <49204EEA.8030605@wasp.net.au>
Date: Sun, 16 Nov 2008 20:48:42 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Tejun Heo <tj@kernel.org>, Linda Walsh <lkml@tlinx.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-ide@vger.kernel.org
Subject: Re: FYI: BUG in SATA Promise 300 TX4 (2.6.24 - 2.6.27-3) w/Linux
References: <491C9A4F.1020801@tlinx.org>	<491FB7E2.2030105@kernel.org> <18719.65298.689618.835202@harpo.it.uu.se>
In-Reply-To: <18719.65298.689618.835202@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> Tejun Heo writes:
>  > > and NOTE: the card or driver (or both) for the Promise 300 TX4 isn't
>  > > stable for production use -- and has a repeatable problem of timing out
>  > > some drives before it can spin-up from standby (just the drive -- not the
>  > > computer).  The error logically removes the drive from the system until
>  > > the next boot (unplugging, and replugging in the SATA cable on the drive
>  > > would hang the machine within 5 seconds of replugging in the cable).  Not
>  > > an instant, hang as might indicated a HW upset plugging in cable, but a
>  > > couple second delay after plugin -- before keyboard would lock up --
>  > > pointing toward the software trying to re-add+initialize the drive.
>  > 
>  > Some promise controllers seem to suffer transmission problems when
>  > combined with certain drives, which often show up as timeouts.  The
>  > hardreset of sata_promise wasn't as robust as it should have been and
>  > in some cases it wasn't able to recover a link after error condition
>  > causing the system to lose drive after such events.  The hardreset
>  > problem was fixed recently by Mikael Pettersson.  Can you please try
>  > 2.6.28-rc5 and see whether sata_promise still loses drives after
>  > failures?
>  > 
>  > Mikael, I think the hardreset fix is worthy including into -stable.
>  > It should be safe for -stable too, right?
> 
> The hardreset fix was included in 2.6.27.5. I wanted it in 2.6.26-stable
> too, but that branch seems to have been closed now.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Is that likely to do anything for the old SATA150-TX4 ?
I have 2 of them in a machine and I've been dropping drives under write load recently but it was a 
2.6.27.4 kernel.

Reboot required to pick up the drives again (unless the kernel panics and it reboots itself - which 
it's been doing also).

Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
