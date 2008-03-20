Return-Path: <linux-kernel-owner+w=401wt.eu-S965059AbYCTAkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965059AbYCTAkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967409AbYCTAa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:30:28 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:37709 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967404AbYCTAaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:30:25 -0400
Message-ID: <47E1B062.4060709@keyaccess.nl>
Date: Thu, 20 Mar 2008 01:31:30 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
CC: David Brownell <david-b@pacbell.net>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200803171700.26274.david-b@pacbell.net> <47DF19AD.405@keyaccess.nl> <200803171855.44552.david-b@pacbell.net> <alpine.LFD.1.00.0803200211230.31035@nev.ubzr>
In-Reply-To: <alpine.LFD.1.00.0803200211230.31035@nev.ubzr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-03-08 00:47, Lev A. Melnikovsky wrote:

> Just in case - I do have an A7V8X-based PC in the office and have 
> performed a simple experiment.
> 
> #1. Idle USB controller has no effect on PCI performance (I again
> measured hda throughput).
> 
> #2. Default value for register 4Bh is 09h.
> 
> #3. I have detected no effect of changing [4Bh]=29h. Particularly, USB 
> FLASH read speed is ~8MB/s and hda read speed is ~40MB/s regardless of 
> [4Bh] content. During hda timing, "dd if=/dev/sda of=/dev/null bs=1024" 
> was running in another window (/dev/sda being the USB stick).
> 
> My interpretation, is that bit5 at offset 4B may _not_ be an "EHCI sleep 
> time select" like it is for VT6212. Am I missing something?

No, very useful test, thanks much. Patch as submitted for revision 0x6x will 
stand then.

I do wonder -- is your hda throughput also the same before _ever_ attaching 
anything to the EHCI controller and after? In my case, the slow down only 
happened after switching on my external USB drive once, and would persist 
from that time until reboot (or unloading ehci-hcd, which I kept modular for 
exactly that reason).

The sleep time wasn't the core problem, so I wonder of later VIA chips do 
still have the active async schedule problem...

Alessandro? You said there still was a difference for you between no EHCI at 
all and EHCI after tweaking 4B as Lev showed. How much?

Rene.
