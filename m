Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYLDMYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYLDMYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbYLDMYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:24:07 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:50833 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYLDMYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:24:05 -0500
Date: Thu, 4 Dec 2008 17:53:49 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, mingo@elte.hu, jason.wessel@windriver.com,
       avi@qumranet.com, richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 6/9] Use virtual debug registers in process/thread
	handling code
Message-ID: <20081204122349.GB5207@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20081018000829.519111544CB@magilla.localdomain> <Pine.LNX.4.44L0.0810181123220.1469-100000@netrider.rowland.org> <20081204010559.AAB5DFC053@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204010559.AAB5DFC053@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 05:05:59PM -0800, Roland McGrath wrote:
> > > Hmm.  The 64-bit version of __switch_to does the current change much
> > > earlier, before __switch_to_xtra and math_state_restore.  I wonder if the
> > > 32-bit version could change to match.  I can't see what in __switch_to_xtra
> > > would care either way, though I may be overlooking something.  Ingo?
> > 
> > Would it be better to move __switch_to_xtra down below the change to 
> > current, rather than moving the change to current up above 
> > __switch_to_xtra?
> 
> I can't see that anything else in __switch_to_xtra cares either way.
> 
> 
> Thanks,
> Roland
>

That the grouse against the placement of
switch_to_thread_hw_breakpoint() is about additional code in the
hot-path, can we deal with this separately through a different patch?

I now have the patchset which provides only data breakpoint facility on
x86 (and x86_64) and has addressed your comments, ported against
2.6.28-rc7 which will be sent shortly. I'm thinking if the suggested
changes to the context-switching code can be handled later.

Thanks,
K.Prasad

