Return-Path: <linux-kernel-owner+w=401wt.eu-S965315AbXA3NF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315AbXA3NF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965341AbXA3NF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:05:27 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57992 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965315AbXA3NF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:05:26 -0500
Date: Tue, 30 Jan 2007 14:05:24 +0100
From: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>, Pavel Machek <pavel@ucw.cz>,
       andi@lisas.de, davej@codemonkey.org.uk,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: intel-agp PM experiences (was: 2.6.20-rc5: usb mouse breaks suspend to ram)
Message-ID: <20070130130524.GA21811@rhlx01.hs-esslingen.de>
References: <d120d5000701160608t73db4405n5d157db43899776a@mail.gmail.com> <20070116142432.GA6171@elf.ucw.cz> <d120d5000701161325h112a9299w944763b7f1032a61@mail.gmail.com> <20070117004012.GA11140@rhlx01.hs-esslingen.de> <20070117005755.GB6270@elf.ucw.cz> <20070118115105.GA28233@rhlx01.hs-esslingen.de> <20070118231650.GA5352@ucw.cz> <20070122044519.GA24398@zhen-devel.sh.intel.com> <20070129213053.GA14881@rhlx01.hs-esslingen.de> <20070130123632.GA28177@zhen-devel.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070130123632.GA28177@zhen-devel.sh.intel.com>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 30, 2007 at 08:36:32PM +0800, Wang Zhenyu wrote:
> On 2007.01.29 22:30:53 +0000, Andreas Mohr wrote:
> Sorry I don't have 815G board nowadays, this board seems has two
> pci devs, one for AGP bridge, another for integrated gfx card if no add-in card.
> So have you tried both cases? 

Does this mean that it has builtin i815 video, too?
How would I be able to "try both cases", then?
I somehow would have to configure it to boot with builtin graphics and
thus show 0x1130 and 0x1132 PCI IDs, right? Help, I'm confused...

> ok, just see the AGP tables bits definition for intel_i815_driver,
> /* Intel registers */
> #define INTEL_APSIZE    0xb4
> #define INTEL_ATTBASE   0xb8
> #define INTEL_AGPCTRL   0xb0
> ...
> And this could explain why your patch can make X come back to live on
> i815, as default suspend saves 64bytes. We need suspend func to handle
> this, but for now mainline intel integrated gfx, this's not needed. 
> Would you send out a cleanup patch later?

OK, I'll keep working on this (trying a backup specific to those registers
above).

I suspect that your patch might actually additionally help in my case, too,
but of course I first need my enhanced PCI space backup to prevent it
from locking up.
IOW, your patch might then enable me to skip vbetool hackery entirely
since graphics mode appearance would already be correct.
I'll verify this.

How to transform all this newly-gained knowledge into a *clean* generic
intel-agp driver layer is a different question, though.
Specifically, I'm unsure about all those xxx_configure() calls in the resume
function, this sounds rather unclean to me...
("let's just yank it all back into a clean default state, that will somehow
magically make everything work again after resume")

Andreas Mohr
