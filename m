Return-Path: <linux-kernel-owner+w=401wt.eu-S1764089AbXJTMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764089AbXJTMxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXJTMxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 08:53:08 -0400
Received: from 133.90.227.87.static.ehn.siw.siwnet.net ([87.227.90.133]:59730
	"EHLO 133.90.227.87.static.ehn.siw.siwnet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbXJTMxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 08:53:07 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Oct 2007 08:53:06 EDT
Date: Sat, 20 Oct 2007 14:42:38 +0200
From: Henrik Carlqvist <hc1@poolhem.se>
To: linux-kernel@vger.kernel.org
Subject: tristate and bool not enogh for Kconfig anymore
Message-Id: <20071020144238.4f258c8c.hc1@poolhem.se>
In-Reply-To: <200710201257.55616.nick@ukfsn.org>
References: <200710201257.55616.nick@ukfsn.org>
X-Mailer: Sylpheed version 0.9.2 (GTK+ 1.2.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think there is a need for Kconfig to specify that a functionality could
be built as a module or not built at all.

Some drivers require that firmware is loaded when the driver is
initialized. The kernel has functionalities for this by using a userspace
program. However, this userspace program is only usable from modules and
not during boot while any initrd or any other file system has not yet been
mounted and yet less any processes started.

For example, Slackware 12 has a huge kernel with a lot of drivers for
different file systems and scsi cards built in. This kernel is supposed to
be a non optimized kernel that works on almost any machine even without an
initrd. In that kernel CONFIG_SCSI_QLA_FC is set to y but still it is not
possible to boot from any of those cards as the driver requires a firmware
file. Even together with an initrd image containing the firmware file it
is still not possible to use the driver as the driver require the firmware
file before any processes has been started from the initrd image.

For such drivers requiring firmware files, or if there is any other reason
that the driver doesn't work when built into the kernel it would be useful
with another choice than bool or tristate.

Best regards Henrik
-- 
NOTE: Dear Outlook users: Please remove me from your address books.
      Read this article and you know why:
      http://newsforge.com/article.pl?sid=03/08/21/143258
