Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbZFOQpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbZFOQpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 12:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760380AbZFOQpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 12:45:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27396 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610AbZFOQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 12:45:32 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5647"; a="19436359"
From: davidb@quicinc.com
Date: Mon, 15 Jun 2009 09:45:32 -0700
To: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>, Nicolas Pitre <nico@cam.org>,
       Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090615164532.GA7190@huya.quicinc.com>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Brian Swetland <swetland@google.com>, Nicolas Pitre <nico@cam.org>,
	Ryan Mallon <ryan@bluewatersys.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Tony Lindgren <tony@atomide.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	David Miller <davem@davemloft.net>,
	lkml <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk" <linux-arm-kernel@lists.arm.linux.org.uk>
References: <4A3175AC.9070100@bluewatersys.com> <alpine.LFD.2.00.0906112105220.31536@xanadu.home> <4A31AECA.6070303@bluewatersys.com> <alpine.LFD.2.00.0906112138090.31536@xanadu.home> <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com> <20090612103521.GD18682@elf.ucw.cz> <a55d774e0906120344p57226dd4ve526f274a2bf7c8e@mail.gmail.com> <a55d774e0906130005v5a35aa60ybabde470ff44cf77@mail.gmail.com> <20090615162150.GC6842@huya.quicinc.com> <20090615162746.GA25040@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615162746.GA25040@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 09:27:46AM -0700, Pavel Machek wrote:

> With right .config file and google's msm tree, running debian is
> fairly easy.
> 
> > The tricky part about something like arm-debian is storage.  You
> > might be able to stick an ext2 on an microSD card, but obviously
> > that's only going to work once the SD driver is functioning.  The
> > phone targets don't generally have ethernet ports on them.
> 
> ext2 on microSD is the key, :-), yes. It boots into multiuser after
> some complains when it tries to access internal NAND (udev?!).

What kind of complaints?  There is some trickiness going on with
the partition table on the NAND, because the CPU running Linux
doesn't have permissions to read the actual partition table.

> The only problem is lack of reasonable keymap. No arrows, no
> escape, no ctrl, no alt, no special symbols... That makes using
> command line very tricky.

Probably related to drivers/char/keyboard.c's

  #warning "Cannot generate rawmode keyboard for your architecture yet."

Does it help to change the change the big block of 'if
defined...' so that CONFIG_ARM isn't dependent on
CONFIG_KEYBOARD_ATKBD?  I'm not sure why that's there, perhaps
there aren't many ARM devices with USB host controllers in them?

David
