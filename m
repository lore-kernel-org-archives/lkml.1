Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbYLDWqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbYLDWqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756580AbYLDWpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:45:53 -0500
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:21125 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754893AbYLDWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:45:52 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkQFAI3sN0lR9dFM/2dsb2JhbACBbc8QgwU
Date: Thu, 4 Dec 2008 23:45:47 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #12162] Commit 7cd5b08be3 breaks startup on Toshiba Portege R500
Message-ID: <20081204224547.GA2212@infomag.infomag.iguana.be>
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera> <bfPM5B8Tx2B.A.bmG.moxNJB@chimera> <alpine.LFD.2.00.0812031632420.3256@nehalem.linux-foundation.org> <20081204080537.GI7017@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204080537.GI7017@infomag.infomag.iguana.be>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> I will test the watchdog part tonight on an ICH4 and ICH9 chipset.
> I indeed moved the code over from the supermicro_old_pre_stop code.
> And I'm sure this fix indeed needs to go in.

Test on ICH4 is OK.
Test on ICH9 -> the watchdog timer runs but doesn't reboot the system anymore.
The following bits are active in SMI_EN and thus need to be investigated:
	13 - TCO_EN (Not relevant since we set/unset this allready)
	 5 - APMC_EN
	 4 - SLP_SMI_EN
	 3 - LEGACY_USB_EN
	 1 - End Of SMI
	 0 - GBL_SMI_EN

A first test indicated that if bit 0 is forced to 0, the system reboots again.
The second test reveals that setting bits 5, 4, 3 and 1 to 0 doesn't help the rebooting of the ICH9 chipset.
So the real issue with ICH9 and rebooting has to do with the GBL_SMI_EN bit.

So next step will be to create an additional patch and then test it with Rafael and Frans...

Kind regards,
Wim.

