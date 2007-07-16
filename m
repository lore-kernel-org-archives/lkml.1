Return-Path: <linux-kernel-owner+w=401wt.eu-S1765465AbXGPAwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765465AbXGPAwM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 20:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759999AbXGPAv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 20:51:57 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:39157 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759823AbXGPAvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 20:51:55 -0400
Date: Mon, 16 Jul 2007 01:51:35 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Huang, Ying" <ying.huang@intel.com>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>
Message-ID: <20070716005135.GB8140@srcf.ucam.org>
References: <200707151433.34625.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707151433.34625.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: Hibernation considerations
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 02:33:32PM +0200, Rafael J. Wysocki wrote:

(snip)

Many of these assumptions are based on the assumption that we want to 
save a full image of RAM. I'm not convinced that this is true. The two 
things that we need are application state and hardware state. 
Application state can clearly be saved without kernel involvement 
(though restoring some of it may need some help from the kernel...), so 
hardware state is a more interesting question.

The obvious argument for saving the entirity of memory is that we have 
no mechanism for picking apart hardware state from any other part of the 
kernel. In reality, we're looking at implementing a set of hibernation 
operations anyway - it would be possible to utilise those to save as 
much state as needed. You also get fringe benefits, like being able to 
freeze a process that's accessing a piece of flaky hardware, swap the 
card out (assuming hotplug PCI), restore some amount of state and then 
let the process continue.

I appreciate that this suggestion sounds kind of fragile and 
complicated, but I think that's true of most descriptions of suspend to 
disk :) The main benefit is that it means we can use the hibernation 
infrastructure for other purposes (checkpointing, swapping hardware, 
that kind of thing) and reduce the damage caused by users doing 
seemingly reasonable things (like suspending Linux, booting Windows and 
then writing to a shared partition...). 

-- 
Matthew Garrett | mjg59@srcf.ucam.org
