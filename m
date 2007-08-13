Return-Path: <linux-kernel-owner+w=401wt.eu-S933462AbXHMW6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462AbXHMW6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbXHMW57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:57:59 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:58392 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbXHMW56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:57:58 -0400
Date: Mon, 13 Aug 2007 23:56:22 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Alexey Starikovskiy <astarikovskiy@suse.de>
cc: Sergey Dolgov <solkaa@gmail.com>, Len Brown <len.brown@intel.com>,
       Norbert Preining <preining@logic.at>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Henrique de Moraes Holshuh <hmh@hmh.eng.br>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3 regression and bisection query
In-Reply-To: <46C0D6DB.7090703@suse.de>
Message-ID: <Pine.LNX.4.64.0708132353480.6269@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708131905280.13982@blonde.wat.veritas.com>
 <20070813212204.GA2645@slk.laptop> <46C0D6DB.7090703@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Alexey Starikovskiy wrote:
> Sergey Dolgov wrote:
> > On Mon, Aug 13, 2007 at 07:44:48PM +0100, Hugh Dickins wrote:
> >
> >   
> >> Git bisection (with manual fixups to i386 mmiocfg horror, thanks
> >> for drawing attention to that in your changelog) accuses Alexey's
> >> ACPI: EC: If ECDT is not found, look up EC in DSDT
> >> cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
> >> and if I revert that along with Len's subsequent
> >> ACPI: EC: fix build warning
> >> 52fe4bdf40bc07498c5f7935551774e8f8458190
> >> then I have Fn-F4 suspending to RAM again.
> >>
> >>     
> >
> > I've also noticed a regression since -rc2 in battery status reporting
> > on my HP nx7300 laptop: the output of
> >
> >     cat /proc/acpi/battery/C1BE/state
> >
> > does not change after this file has been read for the the first time;
> > for exaple, the line "charging state: charged" does not change to
> > "charging state: discharging" upon unplugging the power cord.
> >
> > Reverting the above 2 commits fixes this issue for me.
> >
> > --
> > Sergey
> >   
> Function to register query methods (means by which EC talks to ACPI)
> was deleted by mistake.
> 
> Could you please try the attached patch?

Great, that indeed fixes my Thinkpad suspend-to-RAM cases
(both the Fn-F4, and resume from echo mem >/sys/power/state):
thanks a lot, Alexey.

Hugh
