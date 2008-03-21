Return-Path: <linux-kernel-owner+w=401wt.eu-S1761267AbYCUUBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761267AbYCUUBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 16:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759588AbYCUUBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 16:01:09 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:42869 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439AbYCUUBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 16:01:07 -0400
Date: Fri, 21 Mar 2008 21:01:06 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-kernel@vger.kernel.org
Subject: APM crashes when IO is going on
In-Reply-To: <200803210127.56437.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0803212055550.6726@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz>
 <200803201131.25828.rjw@sisk.pl> <Pine.LNX.4.64.0803210059440.2540@artax.karlin.mff.cuni.cz>
 <200803210127.56437.rjw@sisk.pl>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > > I have an old notebook with APM and I am experiencing occasional APMD 
> > > > lockups after resume, with kernels 2.6.25rc1 snd 2.6.25rc3. They didn't 
> > > > happen with 2.6.24 or before.
> > > > 
> > > > The bug happens about once a week or so.
> > > > 
> > > > If you have any idea how to debug it, you can send me a test code.
> > > 
> > > It is possible that the bug was fixed in -rc4.  Can you please test -rc6 and
> > > see if it's still present?
> > > 
> > > Thanks,
> > > Rafael
> > 
> > I'm now running on -rc6, so I'll see (it takes some days for the bug to 
> > appear). Where is that patch that went to -rc4 and that may fix it?
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7a8d37a37380e2b1500592d40b7ec384dbebe7a0
> 
> Thanks,
> Rafael

I found another problem --- present in 2.6.23.1, 2.6.25rc3, 2.6.25rc6

--- when I run three threads concurrently reading raw disk partition and 
suspend, I get 100% reproducible failure. (with one thread running it 
usually succeeds, sometimes fail)

Either the on-going I/O will jam BIOS and I need to remove power to 
continue.

Or the machine suspends, wakes up and reports "hda: lost interrupt" 
(2.6.23.1 was able to recover from this condition, 2.6.25rc3,6 does not 
recover and it is not able to send any more disk IOs).

How is suspending disk IO supposed to work? And why it doesn't?

Mikulas
