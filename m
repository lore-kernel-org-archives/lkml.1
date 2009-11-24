Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbZKXJ1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbZKXJ1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 04:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932357AbZKXJ1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 04:27:53 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:47026 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340AbZKXJ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 04:27:52 -0500
Message-ID: <4B0BA71B.8040800@ladisch.de>
Date: Tue, 24 Nov 2009 10:27:55 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Monty Montgomery <xiphmont@gmail.com>
CC: Linux kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Der Mickster <retroeffective@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: PATCH: fix multiple eMagic 6|2m regressions introduced in 2.6.27
References: <806dafc20911240054p74bd4d67h97430a02ba86b468@mail.gmail.com>
In-Reply-To: <806dafc20911240054p74bd4d67h97430a02ba86b468@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Monty Montgomery wrote:
> The eMagic driver code cleanup from 2.6.26->2.6.27 introduces three
> new bugs that prevent the emi62 usb audio device from working.  2.6.31
> continues to be identically broken. Note that this is the 6|2, not the
> 2|6; the 2|6 works properly. The 6|2 does not function at all and will
> oops the kernel when plugged in.

This has been discussed in this thread:
http://lists.linuxaudio.org/pipermail/linux-audio-user/2009-November/064931.html

> Bug 1: a mirror of the loop termination bug that was fixed in the 2|6
> driver last January, causing a similar oops as the 2|6 did in 2.6.27.

My patch for this has already been picked up by akpm.

> Bug 2: the firmware load loop that is supposed to load the firmware
> section that sits in the device's RAM mistakenly uses
> ANCHOR_LOAD_EXTERNAL instead of ANCHOR_LOAD_INTERNAL, a bug from
> copy/pasting out of the preceeding loop.  This is clearly a regression
> from the 2.6.26 source which uses the proper target.
> 
> Bug 3: Fixing the first two problems prevents the oops and allows the
> USB stack to successfully allocate an endpoint without crashing the
> eMagic.  However, the eMagic crashes and lights its red INTERNAL ERROR
> led later as it tries to start up.  This problem can be traced to the
> linux/firmware/emi62/bistream.HEX file, which is loading different
> FPGA firmware as compared to the driver pre-2.6.27.
> [...]
> Due to the size of the patch (the replacement firmware file is 250kB),
> I've not attached it but rather stashed it at:
> 
> http://web.mit.edu/xiphmont/Public/emi/emi62.patch

I don't have much time; David, please handle this.


Clemens
