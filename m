Return-Path: <linux-kernel-owner+w=401wt.eu-S1758624AbXE0TEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624AbXE0TEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 15:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXE0TEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 15:04:04 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:51905 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbXE0TED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 15:04:03 -0400
Date: Sun, 27 May 2007 20:03:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: david-b@pacbell.net
Message-ID: <20070527190351.GA21387@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: RTC_DRV_CMOS can break userspace interface
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

f5f72b46c349fefcfd4421b2213c6ffb324c5e56 appears to break the userspace 
interface to the CMOS alarm. This could previously be accessed via 
/proc/acpi/alarm, but if RTC_DRV_CMOS is enabled that vanishes. The help 
text for the module doesn't mention this, which makes tracking it down a 
touch irritating.

I'm not actually sure why this is the case. It doesn't look like the two 
interfaces are fundamentally incompatible. I agree that removing the 
proc code is a good long-term aim, but it'd be nice to be able to test 
the new RTC code without removing existing functionality.

(It doesn't really help that rtc-cmos doesn't load on this machine, but 
I'll try to track that down later - right now I suspect some sort of PNP 
issue)
-- 
Matthew Garrett | mjg59@srcf.ucam.org
