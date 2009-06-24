Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbZFXBdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbZFXBdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 21:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZFXBdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 21:33:03 -0400
Received: from fmailhost03.isp.att.net ([207.115.11.53]:36254 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZFXBdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 21:33:02 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A418254.9050607@lwfinger.net>
Date: Tue, 23 Jun 2009 20:33:08 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Regression with commit f9cde5f in 2.6.30-gitX
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My latest pull from Linus's tree fails to boot. Bisection leads to the
commit entitled "x86/ACPI: Correct maximum allowed _CRS returned
resources and warn if exceeded" with hash
f9cde5ffed17bf74f6bef042d99edb0622f58576. I have been unable to
capture the first error message as it scrolls off the screen, but the
second hits the WARN_ON at drivers/ata/ahci.c:695 in routine
ahci_enable_ahci() because HOST_AHCI_EN is not set.

The modules involved in the disk driver are:

amd74xx                 7152  0
ide_core              107120  2 ide_cd_mod,amd74xx
ahci                   36992  7
libata                168764  1 ahci
scsi_mod              159392  4 usb_storage,sg,sd_mod,libata

Please let me know what other info is needed.

Larry
