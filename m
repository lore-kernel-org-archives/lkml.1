Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbXGaVf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbXGaVf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbXGaVfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:35:08 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47749 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759839AbXGaVfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:35:06 -0400
X-Greylist: delayed 538 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 17:35:06 EDT
Date: Tue, 31 Jul 2007 23:26:06 +0200
From: Andreas Mohr <andi@lisas.de>
To: Daniel Mierswa <impulze@impulze.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Gericom Webboy Laptop Mouse/Touchpad
Message-ID: <20070731212606.GA3643@rhlx01.hs-esslingen.de>
References: <46AF935B.9020403@impulze.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AF935B.9020403@impulze.org>
X-Priority: none
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 31, 2007 at 09:54:03PM +0200, Daniel Mierswa wrote:
> 
> Hi there,
> i'm having troubles getting my mouse and/or touchpad to work with 
> 2.6.21.5 (and older ones). It's putting the following line into dmesg 
> everytime the laptop gets lots of I/O or cpu load.
> "psmouse.c: Wheel Mouse at isa0060/serio4/input0 lost synchronization, 
> throwing 2 bytes away."

This message is a wee bit too familiar to me as well, albeit for reasons
different to that, I believe. :-$

> The problem still exists and seems to occur as i've mentioned on lots of 
> disk i/o and/or cpu load.
> This is a laptop which is not supported by the manufactur anymore (seems 
> to be a Gericom Webboy). I would appreciate any tips to debug this further.
> Please post back for any additional information you need.

Hmm, I'm pondering what I'd do here...
Could it be that you're using the "old" IDE layer (not libata yet) and
hdparm -u or -d or -c is inconveniently set up?

Maybe run powertop to identify timer anomalies?
Try configuring a different CONFIG_HZ?
Or maybe run oprofile to try to figure out any abnormal system load?
And did you try running a "barebone"-only configuration? Possibly some
certain driver is causing this misbehaviour...
vmstat may provide some initial information as to what kind of activity
exactly causes this issue.

Or maybe it's a simple X.org scheduling issue again?
What nice value do you run X.org at?
If it's too low, then maybe this causes the psmouse.c driver to have its
mouse queue(?) processing get stuck and makes it have a hickup?
In this context it would be good to ask about possible memory pressure on
this system, too, since recently some people indicated more fluid X.org mouse
pointer operation when mlocking the pointer handling code to avoid
paging this code.

Oh, given that IIRC the Webboy is a slightly older Gericom model which
thus may easily be a (somewhat hotter) P4 *desktop* CPU: could it be that
you're hitting thermal emergency throttling on increased system activity?
cat /proc/acpi/processor/*/throttling or something there might indicate
this.

HTH,

Andreas Mohr
