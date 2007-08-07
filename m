Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbXHGU2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbXHGU2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbXHGU2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:28:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbXHGU2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:28:02 -0400
Date: Tue, 7 Aug 2007 16:27:58 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: GPL / MPL license issues.
Message-ID: <20070807202758.GA1937@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of files in the kernel that have in their
headers a notice that the file is under the Mozilla Public License,
which alone, is incompatible with the GPL.

This itself is fine, as long as the resulting code claims
to be Dual MPL/GPL, however there are a few cases where this
doesn't seem to be happening.

drivers/pcmcia/soc_common.c gets linked into
drivers/pcmcia/pxa2xx_core.o, which seems to end up with
a module license of "GPL".

ricoh.h and o2micro.h are MPL, yet get included in
drivers/pcmcia/yenta_socket.c which ends up as a "GPL" module.

drivers/pcmcia/i82365.h is MPL, yet gets included in the following
GPL only drivers ..
 drivers/pcmcia/i82092.c
 drivers/pcmcia/pd6729.c
 drivers/pcmcia/vrc4171_card.c
 drivers/pcmcia/yenta_socket.c

drivers/pcmcia/pd6729.c is MODULE_LICENSE("GPL"), yet includes
the MPL'd 'cirrus.h'

drivers/serial/serial_cs.c labels itself as MPL/GPL, yet
has a MODULE_LICENSE("GPL").

drivers/scsi/pcmcia/qlogic_stub.c does the same.

I may have missed some others, but this is what turned up from
some simple grepping.

I've got patches fixing up some of the simpler cases changing
the "GPL" to "Dual MPL/GPL", but I want to be sure I'm not
barking up the wrong tree first.

comments?

	Dave

-- 
http://www.codemonkey.org.uk
