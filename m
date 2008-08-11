Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbYHKND5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbYHKND5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYHKNDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:03:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbYHKNDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:03:47 -0400
Date: Mon, 11 Aug 2008 09:02:56 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Keith Owens <kaos@ocs.com.au>, Jay Lan <jlan@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080811130256.GB28030@redhat.com>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com> <20080808022916.GM24801@one.firstfloor.org> <20080808132953.GB3840@redhat.com> <20080808180303.GB9038@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808180303.GB9038@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2008 at 08:03:03PM +0200, Andi Kleen wrote:
> > Are you suggesting that kdump should be put onto panic_notifier_list, in
> > such a way so that it runs last?
> 
> The point was that kernel debuggers have an at least as legitimate
> need as kdump to run early on panic as kdump. In particularly they
> should run before kdump because kdump can be triggered from
> the debugger.
> 

Agreed.

> But for modular kernel debuggers the hook would need to be exported,
> so in theory everyone could use it. In theory code review should
> catch that. Another alternative would be to readd the old namespaces
> patches I posted some time ago, this allowed to export symbols only
> to specific modules (but that would be also unfortunate for out of tree
> debuggers) 
> 

Or an easier way is that debuggers can put a breakpoint on panic().

> Since we have nearly all other needed hooks for kernel debuggers
> anyways it doesn't really make sense to stop at panic. So this
> earlier requirements should be relaxed.
> 

I think given that so many people want kdump on panic_notifier_list,
it would be worthwhile to experiment with the different approach.

- Move kdump to panic_notifier_list.
- Export panic_notifier_list to user space and provide flexibility
  so that a user can change the priorities of registered handlers
  dynamically.

This will allow an admin to explicitly see who all are goint to run
in what order in case of panic and also give him capability that he
can choose to change the order.

This kind of list should keep all the kind of users happy. Those who
want to run all the other modules before kdump, they will be able to
do so and those who don't want, they can boost the priority of kdump
to put it ahead in the list.

I think Takenori had some working patches in the past for this. Probably
time to revisit the patches. (Somebody willing to look into it?).

Thanks
Vivek
