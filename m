Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZKJCJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZKJCJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:09:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZKJCJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:09:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:33210 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZKJCI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:08:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,712,1249282800"; 
   d="scan'208";a="209591862"
Date: Tue, 10 Nov 2009 10:08:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Martin Knoblauch <spamtrap@knobisoft.de>, linux-kernel@vger.kernel.org
Subject: Re: Likley stupid question on "throttle_vm_writeout"
Message-ID: <20091110020858.GA5749@localhost>
References: <799070.68490.qm@web32608.mail.mud.yahoo.com> <1257780393.4108.343.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257780393.4108.343.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 04:26:33PM +0100, Peter Zijlstra wrote:
> On Mon, 2009-11-09 at 07:15 -0800, Martin Knoblauch wrote:
> > Hi, (please CC me on replies)
> > 
> >  I have a likely stupid question on the function "throttle_vm_writeout". Looking at the code I find:
> > 
> >                 if (global_page_state(NR_UNSTABLE_NFS) +
> >                         global_page_state(NR_WRITEBACK) <= dirty_thresh)
> >                                 break;
> >                 congestion_wait(WRITE, HZ/10);
> > 
> > Shouldn't the NR_FILE_DIRTY pages be considered as well?
> 
> Ha, you just trod onto a piece of ugly I'd totally forgotten about ;-)
> 
> The intent of throttle_vm_writeout() is to limit the total pages in
> writeout and to wait for them to go-away.

Like this:

        vmscan fast => large NR_WRITEBACK => throttle vmscan based on it

> Everybody hates the function, nobody managed to actually come up with
> anything better.

btw, here is another reason to limit NR_WRITEBACK: I saw many
throttle_vm_writeout() waits if there is no wait queue to limit
NR_WRITEBACK (eg. NFS). In that case the (steadily) big NR_WRITEBACK
is _not_ caused by fast vmscan..

Thanks,
Fengguang
