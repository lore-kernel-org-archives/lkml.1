Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbYIZSzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbYIZSzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 14:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYIZSzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 14:55:40 -0400
Received: from khc.piap.pl ([195.187.100.11]:60528 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbYIZSzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 14:55:39 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Frans Pop <elendil@planet.nl>, airlied@gmail.com,
       Jeff Garzik <jeff@garzik.org>, davem@davemloft.net,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jesse.brandeburg@gmail.com
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <20080923.150722.141587696.davem@davemloft.net>
	<200809251156.10648.jbarnes@virtuousgeek.org>
	<alpine.LNX.1.10.0809252218470.3389@pegasus.suse.cz>
	<200809251236.12287.jbarnes@virtuousgeek.org>
	<alpine.LNX.1.10.0809252234400.3389@pegasus.suse.cz>
	<48DC176E.6020807@zytor.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 26 Sep 2008 20:55:36 +0200
In-Reply-To: <48DC176E.6020807@zytor.com> (H. Peter Anvin's message of "Thu\, 25 Sep 2008 15\:57\:50 -0700")
Message-ID: <m38wten3dj.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Okay, I just had a scary and hopefully stupid thought.
>
> Especially Intel often has backchannels between the chipset and the
> Ethernet controller for management functions -- anything from WoL to
> IPMI -- generally over some kind of low-speed serial bus.
>
> We're not in a situation where the EEPROM can be touched from the
> chipset via the SMBus or some other non-CPU channel?

I know next to nothing about SMBus and especially those other
backchannels, but the 82566 product brief :-) lists support for:
- Intel Active Management Technology (AMT) with "System Defence"
  (whatever that means)
- ASF 2.0
I think ASF (Alert Standard Format) is somehow related to IPMI and
uses I^2C or something similar (SMBus).

8254x manual says that the EEPROM is divided into 4 parts: one for
E1000 hw initialization, one for ASF (Ethernet in ASF mode?), one for
external BMC (TCO) (loaded by external BMC from the SMBus) and one for
software only (not used by hardware). Some chips only support #1 (and
#4 of course).

I understand the driver reads the EEPROM using EERD register (which,
according to the manual, requires no additional locking) or drives the
EEPROM directly, with a lock/unlock protocol (using EECD register).
Now some devices lack the lock/unlock bits, but they lack ASF/BMC as
well.

I imagine chips other than 8254x may be different here.

Do we have some "master" bugzilla entry or something like that for
these problems?
-- 
Krzysztof Halasa
