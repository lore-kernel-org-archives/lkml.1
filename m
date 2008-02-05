Return-Path: <linux-kernel-owner+w=401wt.eu-S1759159AbYBESzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759159AbYBESzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbYBESzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:55:20 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60587 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755474AbYBESzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:55:18 -0500
Date: Tue, 5 Feb 2008 13:55:17 -0500
To: Robin Lee Powell <rlpowell@digitalkingdom.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Monthly md check == hung machine; how do I debug?
Message-ID: <20080205185517.GE26259@csclub.uwaterloo.ca>
References: <20080203212155.GF12173@digitalkingdom.org> <200802042140.55521.nickpiggin@yahoo.com.au> <20080205171005.GA9284@digitalkingdom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205171005.GA9284@digitalkingdom.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 09:10:05AM -0800, Robin Lee Powell wrote:
> On Mon, Feb 04, 2008 at 09:40:55PM +1100, Nick Piggin wrote:
> > On Monday 04 February 2008 08:21, Robin Lee Powell wrote:
> > > I've got a machine with a 4 disk SATA raid10 configuration using
> > > md. The entire disk is loop-AES encrypted, but that shouldn't
> > > matter here.
> > >
> > > Once a month, Debian runs:
> > >
> > >     /usr/share/mdadm/checkarray --cron --all --quiet
> > >
> > > and the machine hangs within 30 minutes of that starting.
> > >
> > > It seems that I can avoid the hang by not having "mdadm
> > > --monitor" running, but I'm not certain if that's the case or if
> > > I've just been lucky this go-round.
> > >
> > > I'm on kernel 2.6.23.1, my own compile thereof, x86_64, AMD
> > > Athlon(tm) 64 Processor 3700+.
> > >
> > > I've looked through all the 2.6.23 and 2.6.24 Changelogs, and I
> > > can't find anything that looks relevant.
> > >
> > > So, how can I (help you all) debug this?
> > 
> > Do you have a serial console? Does it respond to pings?
> 
> No and yes.
> 
> > Can you try to get sysrq+T traces, and sysrq+P traces, and post
> > them?
> 
> I played with those after you suggested it, but without serial
> console had no way to capture them.
> 
> I was able to solve the problem, however, like so:

I tend to adjust the max disk speed raid is allowed to use, since the
default of 200MB/s makes the system close to unusable while it is taking
place.  Could having slow disk access be causing things to lock up?

Things made much more sense some years ago when the default was 10MB/s
or something along those lines.

Who has 200MB/s capable hardware anyhow?

--
Len Sorensen
