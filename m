Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYAQSkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYAQSkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYAQSkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:40:18 -0500
Received: from mail.queued.net ([207.210.101.209]:2560 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566AbYAQSkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:40:16 -0500
Date: Thu, 17 Jan 2008 13:40:32 -0500
From: Andres Salomon <dilinger@queued.net>
To: Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org, Jordan Crouse <jordan.crouse@amd.com>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080117134032.4cc1a1cf@ephemeral>
In-Reply-To: <478F25D6.3060503@i4.informatik.rwth-aachen.de>
References: <478E4267.7020509@i4.informatik.rwth-aachen.de>
	<20080116161912.7b449466@ephemeral>
	<20080116165606.3ebc06a4@ephemeral>
	<478F25D6.3060503@i4.informatik.rwth-aachen.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 10:54:30 +0100
Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:

> Andres Salomon schrieb:
> > On Wed, 16 Jan 2008 16:19:12 -0500
> > Andres Salomon <dilinger@queued.net> wrote:
> > 
> >> On Wed, 16 Jan 2008 18:44:07 +0100
> >> Arnd Hannemann <hannemann@i4.informatik.rwth-aachen.de> wrote:
> >>
> >>> Hi,
> >>>
> >>> I'm trying to boot 2.6.24-rc8 on a GEODE LX board (ALIX.3),
> >>> and it hangs during boot:
> >>>
> >>> [   12.689971] NET: Registered protocol family 16
> >>> [   12.703329] geode-mfgpt:  Registered timer 0
> >>> [   12.716149] mfgpt-timer:  registering the MFGT timer as a clock event...
> >>>
> >>
> >> What BIOS are you using?  It's possible that our detection code is
> >> failing to detect in-use timers.
> 
> I'm using v0.99 (latest available).


v0.99 of what?  Jordan seems to think it's an Award BIOS, but I'd like
to make sure.


> Also note when I do enable the mysterios "MFGPT workaround" option in
> the bios the machine hangs directly after:
> [   36.780990] NET: Registered protocol family 16


"MFGPT workaround"?  That sounds a bit frightening.

Presumably, the BIOS is using the MFGPTs, but we're not detecting them as
being in use.

I'm assuming that booting with 'nomfgpt' works for you?


> 
> > 
> > 
> > Also, could you provide a log with the following (untested) patch?  I'm
> > curious how many MFGPTs we're actually detecting as being available, and
> > the existing code is backwards.
> 
> The relevant part would be:
> [   23.092507] NET: Registered protocol family 16
> [   23.105875] geode-mfgpt:  8 MFGPT timers available
> [   23.120247] geode-mfgpt:  Registered timer 0
> [   23.133076] mfgpt-timer:  registering the MFGT timer as a clock event.
> 
> Best regards,
> Arnd Hannemann
> 
