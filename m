Return-Path: <linux-kernel-owner+w=401wt.eu-S1765473AbXGVW31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765473AbXGVW31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbXGVW3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:29:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37412 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090AbXGVW3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:29:17 -0400
Subject: Re: Power Management framework proposal
From: Arjan van de Ven <arjan@infradead.org>
To: david@lang.hm
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707221130380.6350@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm>
	 <1185125189.2714.13.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0707221130380.6350@asgard.lang.hm>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 22 Jul 2007 15:27:20 -0700
Message-Id: <1185143240.2714.24.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 11:56 -0700, david@lang.hm wrote:
> >
> > I have a concern with this approach though. It seems to assume that
> > there is one global thing somewhere that sets the system state; in my
> > experience that is the wrong approach; in fact there is a very definite
> > evidence that there are many decisions on power that are to be made
> > local at a high frequency. An example of this is the processor speed;
> > the ondemand governer does exactly this for the cpus that can switch
> > speeds fast; it's just impossible to beat such a local, fast decision
> > with anything on a global scale.
> 
> the intent was not to have one global call that sets the mode on all 
> devices, but rather have one call for each device/subsystem, just the same 
> call in each case.
> 
> there's also nothing that says that there can only be one thing setting 
> the mode (although that does mean a fourth call 'report_current_mode()' or 
> similar is needed). and if you choose to have two pieces of software 
> managing the same device things could get 'interesting'.
> 
> as for the speed that such decisions need to be made.
> 
> this API is not saying anything about the speed of the decisions.
> it's also not saying anything about if the decision makeing is being done 
> by kernelspace or userspace. it's just providing a common way for whatever 
> software is doing the decision makeing to find out it's options and set 
> the modes.


but it makes for a layer between the device and the setting of the
modes..  which sort of would defeat the option of having things truely
local.

Settings don't mean much in general (in specific cases, maybe), it's the
requirements that matter. The *intent* matters. Linus forced this into
cpufreq way back, and while I and perhaps others thought he was just
being silly, 6 years later it turns out he was absolutely right.

Maybe something else
A power policy management framework doesn't need a unified framework (I
know this for a fact, I'm hoping to release the code within a few
weeks). A unified interface doesn't even help one single bit: the
semantics of each part is *extremely* different even if you make it look
the same; the sameness is only cosmetic.

The consequences of managing a disk vs managing a cpu vs managing the
LCD brightness via the X server are all very different. The tradeoffs
you need to make are all very different. The things you want to control
are all very different. Trying to force a standard interface makes the
interface for a specific subsystem go away from the *actual* best
interface for that subsystem, for no gain since the thing that manages
the policy needs to have different parts for each *anyway*.



Now I realize that the needs for "hard small embedded" are different
from "PC like", and to be honest, I don't think it's entirely possible
to unify them; I don't think it's even worthwhile to pursue that (look
at where those attempts have gotten us so far)... but I suspect even in
the small embedded space a standard, forced and thus unnatural interface
isn't what is needed.


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

