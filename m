Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbYACI0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbYACI0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 03:26:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYACIZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 03:25:58 -0500
Received: from enyo.dsw2k3.info ([195.71.86.239]:42525 "EHLO enyo.dsw2k3.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbYACIZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 03:25:57 -0500
Date: Thu, 3 Jan 2008 09:25:45 +0100
From: Matthias Schniedermeyer <ms@citd.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why is deleting (or reading) files not counted as IO-Wait in
	top?
Message-ID: <20080103082545.GA6516@citd.de>
References: <20080102193503.GA31414@citd.de> <200801030216.44446.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801030216.44446.maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.01.2008 02:16, Maxim Levitsky wrote:
> On Wednesday, 2 January 2008 21:35:03 Matthias Schniedermeyer wrote:
> > Hi
> > 
> > 
> > Currently i'm deleting about 500.000 files on a XFS-filesystem which 
> > takes a few minutes, as i had a top open i saw that 'wa' is shown as 
> > 0.0% (Nothing else running currently) and everything except 'id' is near 
> > the bottom too. Kernel is 2.6.23.11.
> > 
> > So, as 'rm -rf' is essentially a IO (or seek, to be more correct)-bound 
> > task, shouldn't that count as "Waiting for IO"?
> > 
> > The man-page of top says:
> > 'Amount of time the CPU has been waiting for I/O to complete.'
> > 
> > But AFAICT wa only seams to be (ac)counted for writing and not for 
> > reading. I come to that conclusion because, when i fire 'sync' i can see 
> > some percent wa for a few seconds.
> 
> The IOWAIT time is the IDLE time that was spent waiting
> for I/O. (meaning that there were no tasks running, but some were waiting on I/O)
> 
> Thus if you have another task that is not I/O bound, it can run in that time,
> and ideally, you shouldn't notice any I/O slowdown, but the iowait time will decrease.
> 
> It wasn't the case before CFS introduction. I did few tests that showed almost 50% slowdown 
> when running another task in that iowait time.
> It is not longer a problem with CFS.

I can understand that, but in my case nothing else was running, so i 
would expect about 46%-50% wa (Dual Core Processor).




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

