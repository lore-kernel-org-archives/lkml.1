Return-Path: <linux-kernel-owner+w=401wt.eu-S1751585AbZIVTBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbZIVTBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 15:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZIVTBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 15:01:05 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:62802 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZIVTBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 15:01:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=ddGbG3okcRZazA+JhzXbY6Vy6wzUxrAFjJRqIjgPi8XHa1a5vK1XCgLFzwa2QXkmKX
         JCdZ9WpAo4yeiWb1v0/c2+A7yNkQ8tba0ZeGDvF7cTWDbFY+OLko5pmEcxHWXB3lY+KZ
         p4WBNuiJHdiun2+AntW0xUwm94w64lnMTKxnU=
MIME-Version: 1.0
Reply-To: gabe@blackfam.net
Date: Tue, 22 Sep 2009 14:01:06 -0500
Message-ID: <8a15eb2b0909221201k70b9e9darc6fda53f87bfae29@mail.gmail.com>
Subject: TI PCIe-PCI bridge quirks
From: Gabe Black <gabebblack@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The TI XIO2000A/XIO2200A PCIe-PCI bridge (VID: 104C, DID: 8231)
erroneously handles fast back-to-back transfers on its subordinate bus
segment.  The behavior is seen when there are multiple devices
downstream and transfers from both devices result in a fast b2b
transfer.  This confuses the PCIe-PCI bridge and results in data
corruption.

One way to work around the buggy bridge would be to disable fast b2b
transfers on any device on the subordinate bus-segment by writing the
appropriate bits in the device's pci-configspace command register.

Are there any suggestions on how this might be handled?  Should this
be addressed in the kernel?

Thanks,
Gabe Black
