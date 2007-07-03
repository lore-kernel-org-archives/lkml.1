Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbXGCTnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbXGCTnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 15:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761251AbXGCTm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 15:42:57 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:40876 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761188AbXGCTm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 15:42:56 -0400
Date: Tue, 3 Jul 2007 20:42:47 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Message-ID: <20070703194247.GB27098@srcf.ucam.org>
References: <20070703170233.GA25129@srcf.ucam.org> <Pine.LNX.4.44L0.0707031529130.7671-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707031529130.7671-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 03:33:40PM -0400, Alan Stern wrote:
> On Tue, 3 Jul 2007, Matthew Garrett wrote:
> 
> > On Tue, Jul 03, 2007 at 12:57:17PM -0400, Alan Stern wrote:
> > > On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > > > For the suspend to RAM case, that sounds absolutely fine.
> > > 
> > > It's not so good when your suspend process has to wait for the call to 
> > > complete!
> > 
> > Why would it have to? Sorry, I suspect I'm missing something obvious 
> > here.
> 
> Well, the sys_sync() that caused your original problem did exactly 
> that.  It's the reason you get deadlocks, right?

The sys_sync is unnecessary in the first case. There shouldn't be 
anything in the suspend path that's going to require userspace access to 
a device after that device has been suspended.

> I agree that in general the suspend process should not have to wait for 
> a userspace callback to complete.  Indeed, there's no particular 
> reason that anything running during STR should have to wait for 
> something in userspace to complete.  Given that fact, I don't see 
> anything wrong with freezing userspace when doing STR.

There's nothing wrong with it as such, it's just that our implementation 
appears to suck in a myriad of small ways that keep cropping up and 
biting people. Even without the sys_sync(), freezing processes results 
in the suspend failing because syslog is stuck in D state and won't go 
into the refrigerator.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
