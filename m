Return-Path: <linux-kernel-owner+w=401wt.eu-S1756268AbYHBOv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268AbYHBOv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 10:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYHBOvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 10:51:48 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42253 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbYHBOvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 10:51:47 -0400
X-Sasl-enc: 2ZQoq+1uDmRHkpvfCHC+moliH8nL6TNFfb7fU6vLjq4f 1217688704
Date: Sat, 2 Aug 2008 11:51:41 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Norbert Preining <preining@logic.at>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
	shutdown
Message-ID: <20080802145141.GA14626@khazad-dum.debian.net>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de> <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain> <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain> <20080801223657.GD23558@khazad-dum.debian.net> <20080802054204.GB12646@srcf.ucam.org> <20080802143833.GC14069@khazad-dum.debian.net> <20080802144452.GA25565@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802144452.GA25565@gamma.logic.tuwien.ac.at>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Aug 2008, Norbert Preining wrote:
> There something else strange, no idea if that is related, sometimes it
> just hangs after 
> 	Setting the clock.
> That is a message of Debian/sid and probably calls hwclock or something
> similar.

Yes, it is a call to hwclock.  It recently started to cause lockups on my
ThinkPad T43 too (it is a regression of some sort, either in hwclock or the
kernel), but I was too busy to care.  I just removed the hwclock calls on
the init path completely, since my clock is in UTC anyway and they were just
wasting boot time.

Interestingly enough, the hwclock call to SET the clock on the shutdown path
never causes any problems.   This could be a Debian userspace issue, or
hwclock reading of the RTC is broken, but writes are not.

But the thermal hang is something else entirely.  You have at least two
different bugs causing you grief.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
