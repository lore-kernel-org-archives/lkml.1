Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbYAQUmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbYAQUmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 15:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYAQUmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 15:42:07 -0500
Received: from mail.queued.net ([207.210.101.209]:1091 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503AbYAQUmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:42:06 -0500
Date: Thu, 17 Jan 2008 15:42:22 -0500
From: Andres Salomon <dilinger@queued.net>
To: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080117154222.6587864b@ephemeral>
In-Reply-To: <478FB255.5040001@i4.informatik.rwth-aachen.de>
References: <478E4267.7020509@i4.informatik.rwth-aachen.de>
	<20080116161912.7b449466@ephemeral>
	<20080116165606.3ebc06a4@ephemeral>
	<478F25D6.3060503@i4.informatik.rwth-aachen.de>
	<20080117134032.4cc1a1cf@ephemeral>
	<478FB255.5040001@i4.informatik.rwth-aachen.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 20:53:57 +0100
Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:

> Andres Salomon schrieb:
> > On Thu, 17 Jan 2008 10:54:30 +0100
> > Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
> > 
> >> Andres Salomon schrieb:
> >>> On Wed, 16 Jan 2008 16:19:12 -0500
> >>> Andres Salomon <dilinger@queued.net> wrote:
> >>>
> >>>> On Wed, 16 Jan 2008 18:44:07 +0100
> >>>> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
> >>>>
> >>>>> Hi,
> >>>>>
> >>>>> I'm trying to boot 2.6.24-rc8 on a GEODE LX board (ALIX.3),
> >>>>> and it hangs during boot:
> >>>>>
> >>>>> [   12.689971] NET: Registered protocol family 16
> >>>>> [   12.703329] geode-mfgpt:  Registered timer 0
> >>>>> [   12.716149] mfgpt-timer:  registering the MFGT timer as a clock event...
> >>>>>
> >>>> What BIOS are you using?  It's possible that our detection code is
> >>>> failing to detect in-use timers.
> >> I'm using v0.99 (latest available).
> > 
> > 
> > v0.99 of what?  Jordan seems to think it's an Award BIOS, but I'd like
> > to make sure.
> 
> Its an ALIX board from PCEngines, they have their own BIOS
> implementation (tinyBios).
> http://www.pcengines.ch/alix.htm
> 

Ah, okay.  I couldn't find anything about MFGPTs in the available
source, but I did find the following:

http://article.gmane.org/gmane.linux.distributions.voyage.general/1824

It would appear that something between 0.90 and 0.92 changed that
has broken things.  There's also a changelog here:

http://forum.pfsense.org/index.php?topic=6729.15

Note two MFGPT-related entries in 0.92:
	
	- disable CS5536 diverse device power management to avoid
MFGPT /
	  interrupt issues.
	
	- MFGPT issues: please observe AMD CS5536 data book section
5.16.3,
	  incorrect initialization sequence can HANG the system.


I'm assuming the first is messing w/ DIVIL_GLD_MSR_PM...


