Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZKLVHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZKLVHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 16:07:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZKLVHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 16:07:20 -0500
Received: from khc.piap.pl ([195.187.100.11]:35901 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbZKLVHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 16:07:19 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Subject: Re: Reading /dev/mem by dd
References: <4AFACC03.7080209@mayc.ru> <4AFB2822.30906@gmail.com>
	<20091112021209.GA21625@khazad-dum.debian.net>
	<878web7kwf.fsf@basil.nowhere.org>
	<1258047454.16197.1344913359@webmail.messagingengine.com>
Date: Thu, 12 Nov 2009 22:07:22 +0100
In-Reply-To: <1258047454.16197.1344913359@webmail.messagingengine.com>
	(Henrique de Moraes Holschuh's message of "Thu, 12 Nov 2009 15:37:34
	-0200")
Message-ID: <m3639flaet.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Henrique de Moraes Holschuh" <hmh@hmh.eng.br> writes:

> In this case, the problem seems to be access over /dev/mem to stuff the
> kernel is already taking care of.

Not sure if local APIC counts as "PCI space and the BIOS code and data
regions" but:

$ grep STRICT_DEVMEM -A 15 arch/x86/Kconfig.debug
config STRICT_DEVMEM
        bool "Filter access to /dev/mem"
        ---help---
          If this option is disabled, you allow userspace (root) access to all
          of memory, including kernel and userspace memory. Accidental
          access to this is obviously disastrous, but specific access can
          be used by people debugging the kernel. Note that with PAT support
          enabled, even in this case there are restrictions on /dev/mem
          use due to the cache aliasing requirements.

          If this option is switched on, the /dev/mem file only allows
          userspace access to PCI space and the BIOS code and data regions.
          This is sufficient for dosemu and X and all common users of
          /dev/mem.

          If in doubt, say Y.

> Certainly "as safe as possible" does
> not have to mean making /dev/mem useless for whatever good uses it has.

For debugging you need absolutely full access to whole address space(s).
One mistake (or intentional action) and the system is dead, this is by
design. It's BTW not very dangerous, compared to accessing flash
ROM/EEPROM/"fuses"/FPGA/CPLD/etc.
-- 
Krzysztof Halasa
