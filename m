Return-Path: <linux-kernel-owner+w=401wt.eu-S1755927AbYHXREg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927AbYHXREg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 13:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbYHXRE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 13:04:28 -0400
Received: from kuber.nabble.com ([216.139.236.158]:33088 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYHXRE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 13:04:27 -0400
Message-ID: <19132349.post@talk.nabble.com>
Date: Sun, 24 Aug 2008 10:04:27 -0700 (PDT)
From: Tachwali <ytachwali@signalogic.com>
To: linux-kernel@vger.kernel.org
Subject: PCI device problem ... how can I debug it guys?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: ytachwali@signalogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I am experiencing a problem with PCI device on local PCI bus governed by the
MV64662 chip in our board. The board runs Gentoo with kernel 2.6.9. The PCI
device is trying to master PCI bus and access the SDRAM behind the MV64662
chip.

The general description of the problem is that the driver at initialization
writes a pattern "0xfeedface" to specific allocated memory locations in
SDRAM behind the MV64662 chip and upon an interrupt, the interrupt handler
checks these memory locations to see whether they have beed edited to check
the validity of the interrupt (not a spurious one). In my case, the driver
*always* finds the memory is not edited (the driver reads back the same
pattern 0xfeedface) and quit the interrupt handling. Although, an interrupt
is actually have been issued by the PCI device.

I tried to access the SDRAM using a basic read/write memory software to
check the PCI device driver activity on the SDRAM. I used the physical
address used by the driver to access the SDRAM but it seems that the driver
does not write to that physical address. Some IO mapping is going on. or it
could be some kernel configs. I am not sure :(

Have you guys encountered a similar problem? I would appreciate any help or
guidance on this matter or suggesting any areas to look at. Thank you all
-- 
View this message in context: http://www.nabble.com/PCI-device-problem-...-how-can-I-debug-it-guys--tp19132349p19132349.html
Sent from the linux-kernel mailing list archive at Nabble.com.

