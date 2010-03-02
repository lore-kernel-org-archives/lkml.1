Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab0CBVW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 16:22:28 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35784 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab0CBVWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 16:22:25 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 RFCv4] add support for Janz MODULbus devices
Date: Tue,  2 Mar 2010 13:22:06 -0800
Message-Id: <1267564929-9324-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.0.1.61.gdc05d
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 02 Mar 2010 13:22:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for the Janz CMOD-IO carrier board, as well
as the Janz VMOD-ICAN3 Intelligent CAN controller and the Janz VMOD-TTL
Digital IO controller. The CMOD-IO carrier board is a PCI to MODULbus
bridge, into which plug MODULbus daughterboards.  I only have access to two
types of daughtercards, the VMOD-ICAN3 and VMOD-TTL boards mentioned above.

The CAN driver has been tested under high loads. I am able to generate ~60%
bus utilization. With two VMOD-ICAN3 boards looped back to each other,
neither one loses any packets when only a single board is generating
packets at maximum speed. Once both boards start generating packets, one
board will sometimes loose arbitration, and cause some lost packets.

RFCv3 -> RFCv4:
- addressed many review comments
- switch to NAPI
- add TX flow control
- mark functions with __devinit and __devexit
- add sysfs readout of MODULbus number (hex switch)
- implement GPIO driver for VMOD-TTL

RFCv2 -> RFCv3:
- addressed many review comments
- correct CAN bus error handling
- use struct device to track subdevices
- use structures for register layout
- add lots of #defines for register values
- use better function prefixes

RFCv1 -> RFCv2:
- converted to a multi-driver model
- addressed many review comments
- added CAN bus error handling
- use a work function only instead of work + NAPI
- use SJA1000 bittiming calculation code

I appreciate any review you can offer.

Thanks,
Ira
