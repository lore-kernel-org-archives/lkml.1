Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYCISvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYCISvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYCISu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:50:56 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3126 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750967AbYCISuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:50:55 -0400
Date: Sun, 9 Mar 2008 14:50:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
cc: LKML <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Adam Belay <abelay@novell.com>, Lee Revell <rlrevell@joe-job.com>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
In-Reply-To: <20080309151659.63d54f38@mjolnir.drzeus.cx>
Message-ID: <Pine.LNX.4.44L0.0803091447090.13999-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Pierre Ossman wrote:

> I'm beginning to think this is a lost cause. I've tried several variants, all without satisfactory results.
> 
> In case anyone else has any more ideas, I'll detail what I've found influences the noise:
> 
> 1. C state
> 
> This is the big one. There is no noise as long as C3 is avoided (processor.max_cstate).
> 
> 2. uhci_hcd driver
> 
> USB is somehow involved in this problem. Unloading the uhci_hcd driver almost entirely kills the noise on a 1000 HZ NO_HZ kernel. On a 100 HZ, no NO_HZ kernel, the effect is very small, but still there.
> 
> 3. Low speed USB devices
> 
> Related, the noise goes away if I insert a USB mouse (low speed). A high-speed device does not effect the noise, neither does the two built-in low speed devices (a fingerprint reader and a bluetooth host).

The relation to UHCI probably has to do with ongoing DMA.  The amount
of DMA varies according to whether or not the USB devices are
suspended, whether or not they have drivers, and the speed at which 
they run.

You can test whether suspending the onboard USB devices changes 
anything.  See Documentation/usb/power-management.txt.

Alan Stern

