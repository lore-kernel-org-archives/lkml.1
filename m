Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYHHSC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYHHSC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbYHHSCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:02:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60522 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYHHSCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:02:17 -0400
Date: Fri, 8 Aug 2008 20:03:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Keith Owens <kaos@ocs.com.au>,
       Jay Lan <jlan@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080808180303.GB9038@one.firstfloor.org>
References: <20080807200659.GJ24801@one.firstfloor.org> <23175.1218148134@ocs10w> <20080808011500.GA531@redhat.com> <20080808022916.GM24801@one.firstfloor.org> <20080808132953.GB3840@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080808132953.GB3840@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Are you suggesting that kdump should be put onto panic_notifier_list, in
> such a way so that it runs last?

The point was that kernel debuggers have an at least as legitimate
need as kdump to run early on panic as kdump. In particularly they
should run before kdump because kdump can be triggered from
the debugger.

But for modular kernel debuggers the hook would need to be exported,
so in theory everyone could use it. In theory code review should
catch that. Another alternative would be to readd the old namespaces
patches I posted some time ago, this allowed to export symbols only
to specific modules (but that would be also unfortunate for out of tree
debuggers) 

Since we have nearly all other needed hooks for kernel debuggers
anyways it doesn't really make sense to stop at panic. So this
earlier requirements should be relaxed.

Perhaps code review can solve the problem?

-Andi
