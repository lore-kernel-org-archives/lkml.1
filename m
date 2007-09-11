Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbXIKNdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbXIKNdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbXIKNc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:32:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41945 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbXIKNcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:32:55 -0400
Date: Tue, 11 Sep 2007 15:32:29 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: r8169: instant reboot and interface renaming
Message-ID: <20070911153229.2dc8cc03@laptopd505.fenrus.org>
In-Reply-To: <1189514631.20015.108.camel@frg-rhel40-em64t-04>
References: <1189514631.20015.108.camel@frg-rhel40-em64t-04>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 14:43:51 +0200
Xavier Bestel <xavier.bestel@free.fr> wrote:



Hi,

> At boot, the kernel says:
> r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
> eth0: RTL8169s/8110s at 0xe0848400, 00:1b:2f:2b:b3:b4, IRQ 17
> 
> but then eth0 doesn't exist and is renamed to eth3. Does anybody know
> why, and how to get it back to eth0 ? There's probably a FAQ on this
> somewhere, but I couldn't find it.

this is userspace doing "eth name by MAC address", your new card has a
different MAC address than your old card, the userspace application
tries to bind each name uniquely to an ethX name so it keeps eth0 free
for your old card.

If you have a RH/Fedora like distribution, you can hack out the mac
address from the /etc/sysconfig/network-scripts/ifcfg-eth0 file

> 
> 
> The other problem I have is, as soon as I do
> ifconfig eth3 up
> the machine is rebooting (like if I pressed the reset button).
> Adding "acpi=noirq" to the boot cmdline seems to solve this, but
> I wonder if it's the proper
> solution ?

it's obviously not the proper solution :)
it's odd though; it could entirely be a bios bug. you may want to file
a bug at bugzilla.kernel.org against the acpi component, and make sure
you include the full dmesg of a boot at least...

Greetings,
   Arjan van de Ven
