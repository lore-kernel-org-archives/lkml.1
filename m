Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbXJCVMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbXJCVMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbXJCVMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:12:33 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1935 "EHLO myri.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752694AbXJCVMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:12:32 -0400
Message-ID: <470405BB.2000208@myri.com>
Date: Wed, 03 Oct 2007 17:12:27 -0400
From: Loic Prylli <loic@myri.com>
User-Agent: Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: MSI problem since 2.6.21 for devices not providing a mask in their
 MSI capability
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We observe a problem with MSI since kernel 2.6.21 where interrupts would
randomly stop working. We have tracked it down to the new
msi_set_mask_bit definition in 2.6.21. In the MSI case with a device not
providing a "native" MSI mask, it was a no-op before, and now it
disables MSI in the MSI-ctl register which according to the PCI spec is
interpreted as reverting the device to legacy interrupts. If such a
device try to generate a new interrupt during the "masked" window, the
device will try a legacy interrupt which is generally
ignored/never-acked and cause interrupts to no longer work for the
device/driver combination (even after the enable bit is restored).


Is there anything apart from irq migration that strongly requires
masking? Is is possible to do the irq migration without masking?



Loic

