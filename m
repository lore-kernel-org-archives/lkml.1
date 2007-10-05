Return-Path: <linux-kernel-owner+w=401wt.eu-S1764155AbXJEUqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764155AbXJEUqW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761666AbXJEUqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:46:13 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52217 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760911AbXJEUqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:46:12 -0400
Message-ID: <4706A28E.7080306@garzik.org>
Date: Fri, 05 Oct 2007 16:46:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Kuan Luo <kluo@nvidia.com>,
       Mark Lord <liml@rtr.ca>, Alan <alan@lxorguk.ukuu.org.uk>
Subject: libata-dev.git rebased; ACPI turned on
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


1) I just rebased libata-dev.git and all its branches.  If you are 
unfamiliar with git rebasing, this means you must either re-clone, or 
force-update your branch like this:

# grab latest nv-swncq branch
URL=git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
cd /local/repo/libata-dev
git-checkout master	# or any branch other than what
			# is being updated
git-fetch -f $URL nv-swncq:nv-swncq	# force update of 'nv-swncq'


2) libata ACPI support has been turned on by default.  So let's be alert 
for problems related to that.  Problems will _probably_ fall into one of 
those categories:
* suspend/resume glitches
* problems related to the new ATA commands we are sending to the drive, 
as passed to us from the BIOS ACPI tables
	
On the upside, this should make libata suspend/resume a lot more sane.


3) I had to yank the FIFO drain patch.  Alan says that the FIFO drain 
patch that went in causes problems on some chips, and that we cannot 
apply it unconditionally to all SFF controllers.  He recommends a new 
->drain_fifo() hook, with a default ata_sff_drain_fifo() implementation 
matching what Mark Lord previously submitted.

	Jeff



P.S.  I still have some more patches to apply, but they should not 
require a rebase.
