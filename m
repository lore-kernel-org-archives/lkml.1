Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXEGBmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXEGBmw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXEGBmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:42:52 -0400
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:25343 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753388AbXEGBmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:42:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=sdF4qU72c8uWS85uXFdkzJUTD2OtUul/LFLSfRoq7vnZp/L1KFKWIoC0l+Hm5xzl/KWsAShiFcVbVDhzE90Kp1fFHnV3V3wBX+Cq54l8nvZt7H74G4PFjI/AzUGH2ay2ZmxPBuLoJueXe94i/oJ0RI0Zz4dcKXZ+UGVCIAIxnlo=  ;
X-YMail-OSG: fos973EVM1nrKB5ijhlp76SPBMJsi7.GiexXRylozgIxlqYaRkpXhU80PPsp8wfI9viNPMZ.4A--
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <cbou@mail.ru>
Subject: Re: [PATCH 2/7] [RFC] Common power driver for Linux gadgets
Date: Sun, 6 May 2007 18:39:27 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
References: <200704122306.46518.david-b@pacbell.net>
In-Reply-To: <200704122306.46518.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705061839.27477.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007, David Brownell wrote:
> > This driver used to stop code/logic duplication through different
> > machines we porting at handhelds.org. pda_power register machs' power
> > supplies, and will take care about notifying batteries about power
> > changes through external power interface.
> 
> It gets USB power management wrong though. ...

And that seems not to have been resolved in the version you
reposted and then put into your GIT tree, either ... what's
your plan for addressing the feedback, then?


> Key points:
> 
>  - The API needs to say *how much power* can be drawn.  ...
> 
>  - Sensing VBUS power is not the same thing as being allowed to consume
>    it.  Again, USB OTG devices are different...
> 
> In general, no component other than the USB peripheral (or host) controller
> driver has any business trying to control how VBUS power is used.  It's
> likely to get it wrong ... as shown by this patch.  ;)

I see on other LKML threads that folk are spreading misinformation
about USB, like "no control signaling over USB for power control".
I sincerly hope you're not believing that's correct!


Plus, I'm wondering why this doesn't try to leverage the voltage
framework that's been posted (to the ARM list, most recently).

At some level there's not a lot different between saying "turn on
the 3V3 supply to this MMC card slot, budgeting 80mA" and saying
instead "let the system draw up to 200 mA from USB VBUS".  The
current goes in different directions in those examples, sure.  Plus
the usage of VBUS as a power _input_ is of course board-specific:
battery charging, or powering specific circuits (like USB), etc.

Then there are devices which _output_ power on VBUS of course ...
so the only difference between that and the MMC example being how
much of the power budget is consumed.  Plus devices which either
use VBUS as an input or an output, based on how they're hooked up.

All of those are differences that seem to fit better into the notion
of a general purpose voltage framework than this "power" thing
you've provided.  (Batter management being a separate issue.)


Also that whole notion that there's only a handful of power "supplies"
to manage ("ac", "main-battery", "usb") just flies in the face of
how most boards actually work -- multiple voltage rails and switches,
more types than battery/UPS/"AC"/USB, etc -- and the mechanisms needed
to manage power when it's critical to eke out every last milliWatt.

- Dave
