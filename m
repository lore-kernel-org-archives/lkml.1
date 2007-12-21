Return-Path: <linux-kernel-owner+w=401wt.eu-S1762521AbXLUOoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762521AbXLUOoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXLUOoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:44:18 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:54035 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbXLUOoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:44:17 -0500
Date: Fri, 21 Dec 2007 09:44:15 -0500 (EST)
From: Jim Faulkner <jfaulkne@ccs.neu.edu>
To: Brian <bcearl@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: sb live (emu10k1) stops working between 2.6.23.1 and 2.6.23.7
In-Reply-To: <1a8e6a68-053a-4148-83b9-417bcd19b732@e4g2000hsg.googlegroups.com>
Message-ID: <Pine.GSO.4.58.0712210925050.17976@denali.ccs.neu.edu>
References: <9qhy2-5v-13@gated-at.bofh.it> <9qzv5-36l-21@gated-at.bofh.it>
 <1a8e6a68-053a-4148-83b9-417bcd19b732@e4g2000hsg.googlegroups.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Brian,

The solution is here:
http://linux.derkeiler.com/Mailing-Lists/Kernel/2007-11/msg06482.html

You just need to run "alsactl -F restore" to force restoration of your
previous settings.  This needs to be done while /etc/asound.state consists
of your settings that work correctly under your previous kernel.
Hopefully Fedora hasn't already overwritten /etc/asound.state, I actually
manually run alsactl from /etc/rc.local and disable the alsa service just
to prevent my settings from being overwritten.

If your settings have already been overwritten, you may need to boot into
the old kernel, get it working, save the alsamixer settings (alsactl
store), reboot to the new kernel, then run "alsactl -F restore".  A
hassle, I know.

You might want to report this bug to the Fedora bug tracking system -- in
my opinion these kind of changes should not be made just for a minor
kernel update.

I also wonder if it is even possible to get digital output working under
newer kernels without an existing asound.state -- I tried in vain for
hours to get it working again by just using alsamixer, and I wasn't
getting anywhere.  asound.state consists of 225 controls for my SB Live,
and only 40 or so are exposed in alsamixer.  I wonder if alsamixer isn't
exposing the necessary control to enable digital output under newer
kernels.

Jim


On Thu, 20 Dec 2007, Brian wrote:

> Hi Jim,
>
> I've come across the exact same issue with my Creative Audigy ZS 2 and
> its digital output...  the sound no longer works after I upgraded my
> kernel to 2.6.23.8-34.fc7 (I'm running Fedora 7).  Same error message
> when using alsactl, etc.  I'm trying to fix this, and I'm not quite
> sure exactly what you mean by "Simply replacing the 2.6.23.7
> emumixer.c with the version included in 2.6.23.1 I was able to get
> digital output working again under 2.6.23.7".  Could you explain in
> further detail how I would go about doing this to fix this problem?
> Would this require the kernel to be recompiled with the different
> emumixer.c file?
>
> I'm starting to wonder if I should just wait it out for another kernel
> update that will hopefully have this issue fixed rather than spending
> so much time on it trying to fix it now.
>
> Any help you can provide is very much appreciated.
>
> Thanks in advance.
>
> Brian
>
