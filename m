Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbYCAMcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbYCAMcd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 07:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754299AbYCAMc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 07:32:26 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:33524 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbYCAMcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 07:32:25 -0500
Date: Sat, 1 Mar 2008 13:31:27 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080301133127.0a85f319@mjolnir.drzeus.cx>
In-Reply-To: <20080229214407.GC1289@csclub.uwaterloo.ca>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx>
	<20080229214407.GC1289@csclub.uwaterloo.ca>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 16:44:07 -0500
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> On Fri, Feb 29, 2008 at 07:38:12PM +0100, Pierre Ossman wrote:
> > +/*
> > + * The minimum number of ticks needed to not oscillate faster than
> > + * 500 Hz.
> > + */
> > +#define MIN_DEEP_INTERVAL (HZ / 500)
> 
> What happens here if HZ < 500?  Or does the fact that you have less than
> 500HZ jiffies automatically imply that you can't go to sleep more than
> the jiffy rate times per second?

A low HZ will still go to sleep very often (provided NO_HZ is in effect). But a HZ < 500 makes that number up there turn to zero.  But the check further down makes sure that at least 1 tick passes. So that means it will not enter C3 more often than min(HZ, 500) Hz. Another reason to stop using jiffies.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
