Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYJGU0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYJGU0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 16:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYJGU0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 16:26:17 -0400
Received: from 1wt.eu ([62.212.114.60]:4639 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbYJGU0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 16:26:15 -0400
Date: Tue, 7 Oct 2008 22:26:11 +0200
From: Willy Tarreau <w@1wt.eu>
To: Klaus Ethgen <Klaus@Ethgen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [KERNEL] Re: [KERNEL] Re: Kernel freeze on 2.4.36.7
Message-ID: <20081007202611.GA16927@1wt.eu>
References: <20081005154113.GA8387@ikki.ethgen.de> <20081005171818.GJ24654@1wt.eu> <20081005204247.GA3781@ikki.ethgen.de> <20081005210144.GA7980@1wt.eu> <20081006081907.GA12913@ikki.ethgen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006081907.GA12913@ikki.ethgen.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Klaus,

On Mon, Oct 06, 2008 at 09:19:07AM +0100, Klaus Ethgen wrote:
> > > > Also, have you ever been running and older 2.4 kernel not causing this
> > > > problem ?
> > > 
> > > I did buy the scanner only days ago. I did not use older kernels since
> > > then. (I have to compile some if it is needed.)
> > 
> > OK, so we'll assume it's not a regression and has always been like that,
> > which is the most likely.
> 
> I'm not absolutely sure but when I remember correct I did use USB
> keyboard before in older ages. But I do not be absolutely sure if I test
> to unplug it that time.

OK. I found a USB keyboard so if I find a theorical corner case, I might
be able to experiment.

> > OK. I see an nvidia module. Would this machine happen to run under X ?
> 
> Yes. I need to use the nvidia module to use the machine. But I do not
> use that crazy window manages than kde or gnome which do some special
> think with your devices hidden from the user.
> 
> > If so, did you configure X so that it directly references the HID devices ?
> 
> What do you mean with "directly"? I use evdev for mouse but the keyboard
> is just normal keyboard with some Xkb settings for the layout.

OK. I was asking if there was anything such as Device "/dev/hid/..." or
Device "/dev/input/..." in the Keyboard section, but judging by your
response, we might have almost the same basic X config file :-)

> > Also, could you tell us a bit more about the application, and how you have
> > to proceed to avoid the problem ? Eg: quit the application then X, etc...
> 
> Just sync several times in front of unplugging the device helps. I can
> reproduce the bug right after a boot without logging in under X (Just
> kdm running). But if I use sync the problem is gone.
> 
> I imagine that it might be something to do with a incompatibility
> between HID and one filesystem driver. I saw this issue in the past with
> ext3 which was very dirty in the past.

That's the part I really don't get. It's quite amazing that finishing
writes onto a file system avoids kernel panics on USB keyboard. Oh,
could you check /proc/interrupts to ensure that your USB interrupts
are not shared with any block device, just in case ? It would constitute
a very thin beginning of a track for investigation.

> Actually I use reiserfs, ext3, and ext2. Might it be that there is some
> shared memory used between that both subsystems? Ah, and before I forget
> to mention, I use the cryptoloop-jari patch to use encrypted swap and
> so.

Hmm interesting. Could you at least try to reproduce with swap turned off ?
No idea why, but I'm just trying to bissect the problem.

> > OK. Before I ask you to do so, could you send me privately your System.map,
> > a copy of /proc/ksyms and your vmlinux (not vmlinuz) ?
> 
> Yup, I will send it later. But why vmlinuX and not vmlinuZ? I thought
> that this both is the same.

No, vmlinuz is stripped and has some boot code prepended (reason why I
asked specifically). vmlinux has all symbols and may easily be disassembled.

BTW, I confirm that I've received them in another mail, thanks.

I don't have much time right now, but I have the files and will check
what can be found. I might get back to you for complementary information,
though I need to get a few ideas of the problem first.

Regards,
Willy

