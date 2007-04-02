Return-Path: <linux-kernel-owner+w=401wt.eu-S933947AbXDBGuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbXDBGuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933962AbXDBGuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:50:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:33568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933947AbXDBGum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:50:42 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 17/17] Add a sched_clock paravirt_op
Date: Mon, 2 Apr 2007 08:50:32 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, john stultz <johnstul@us.ibm.com>
References: <20070402055652.610711908@goop.org> <200704020809.42373.ak@suse.de> <4610A70A.7010105@goop.org>
In-Reply-To: <4610A70A.7010105@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020850.32274.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 08:47, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > I think it would be much cleaner if you didn't implement your own sched_clock,
> > but you adjust ns_base/last_tsc to account for your lost cycles.
> > This could be done cleanly by adding a new function to sched-clock.c
> > Possibly such a function could be used by other parts of the kernel
> > in the future too.
> >   
> 
> Cleaner how?  This seems pretty to me.  Xen can return a
> clock measuring unstolen nanoseconds, 

Do you also get a clock for stolen nanoseconds? 

> which maps directly to the 
> sched_clock interface, doesn't need any of the existing sched_clock
> code.  I suppose I could map the Xen interface onto some abstract
> "cycles" notion and hook it into the tsc machinery, but it seems like it
> would be a forced fit.  In general, my approach has been to choose the
> higher-level interface over a lower-level one, all other things being equal.

No need for cycles, you could just subtract the stolen ns if you
can get those.

-Andi
