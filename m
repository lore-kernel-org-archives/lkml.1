Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbYJZDnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbYJZDnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 23:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYJZDnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 23:43:47 -0400
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:45393 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYJZDnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 23:43:46 -0400
X-Greylist: delayed 1639 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Oct 2008 23:43:46 EDT
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Francois Valenduc <francois.valenduc@tvcablenet.be>
Subject: Re: [Bug #11841] plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg
References: <bqZlc-1BT-11@gated-at.bofh.it> <bqZuJ-22l-15@gated-at.bofh.it>
From: Sanjoy Mahajan <sanjoy@mrao.cam.ac.uk>
Date: 26 Oct 2008 03:16:25 +0000
In-Reply-To: <bqZuJ-22l-15@gated-at.bofh.it>
Message-ID: <r6ljwccagm.fsf@skye.inf.phy.cam.ac.uk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following bug entry is on the current list of known regressions
> from 2.6.27.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11841
> Subject : plenty of line "ACPI: EC: non-query interrupt received, switching to interrupt mode" in dmesg

I see these messages already with 2.6.27.3:

  # grep non-query /var/log/dmesg
  [    0.205977] ACPI: EC: non-query interrupt received, switching to interrupt mode

There are 9 more occurrences in the current ring buffer:
  # dmesg |grep non-query | wc -l
  9

Each one happens right after waking from S3 sleep, for example:

  [70168.288590] CPU1 is up
  [70168.288594] ACPI: Waking up from system sleep state S3
  [70169.624254] ACPI: EC: non-query interrupt received, switching to interrupt mode

The setup is a TP T60 w/ Intel graphics, wireless (i.e. no taint),
Debian unstable, but with vanilla kernel 2.6.27.3.

-Sanjoy
