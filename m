Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYFAV2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYFAV2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYFAV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:28:40 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:51867 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751474AbYFAV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:28:39 -0400
Date: Sun, 1 Jun 2008 22:28:37 +0100
From: Ben Dooks <ben@fluff.org>
To: Martin Samuelsson <sam.linux.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Multiple Zoran MJPEG cards and i2c misattachments
Message-ID: <20080601212837.GA10699@fluff.org.uk>
References: <5a8e970805311139r1355cfccy6933605f7b6441b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a8e970805311139r1355cfccy6933605f7b6441b6@mail.gmail.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 08:39:25PM +0200, Martin Samuelsson wrote:
> Hello,
> 
> I'm working on avs6eyes improvements in the current kernel. As I've
> equipped my machine with no less than three MJPEG-cards; Buz, 6 Eyes
> and DC10+, I happened to run into a bit of a snag:
> 
> saa7185, the video encoder of the Buz, and bt866, video encoder of the
> 6 Eyes, share the same i2c address, 0x88. This should not be a
> problem, because they are connected to different i2c buses, and are
> initialized separately. However, zoran_card.c, via i2c_bit_add_bus(),
> creates one i2c bus for each card in the detection loop, and makes
> them available system-wide. This means that the saa7185 driver, as the
> cards are detected in Buz, 6 Eyes, DC10+ order in my computer, is
> being requested by the zoran driver and initializes itself (not very
> much to do, as there is not yet any i2c bus). The zoran driver then
> creates bus 0, and initializes the saa7185 driver once again, it finds
> bus 0 and a chip at 0x88, which it attaches to.
> 
> Now, that bus is visible to the system. The 6 Eyes is being
> initialized, the bt866 driver loaded, and it initializes itself.
> Here's the problem: At load, the drivers automatically searches the
> system for available buses. bt866 finds bus 0, belonging to Buz, and a
> chip at 0x88, which it promptly attaches to, marking itself as in use.

Do each of the devices creating the i2c busses know what devices are
on the i2c bus at time of creation? If so then the use of the new
style driver addition and device binding would be far more appropriate
to this, as the i2c devices will be bound depending on the device list
registered at bus creation time.

> What would be a working approach to fix this situation? I'm woefully
> unaware of the i2c intricacies in the kernel, and know no immediate
> fix.
> 
> Is it possible to register i2c buses that are not visible to drivers
> you modprobe? That would prevent the initial scan of the buses, and
> the misattachments. zoran_card.c explicitly initialize the correct
> drivers after bus creation anyway.

See above, i've not had time to go through and read all the drivers
outside of drivers/i2c yet

PS, this should have probably gone to the i2c list as well, and
probably the linux-dvb list too.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
