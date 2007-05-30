Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbXE3EGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbXE3EGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 00:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbXE3EGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 00:06:14 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:37829 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbXE3EGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 00:06:13 -0400
Date: Tue, 29 May 2007 22:01:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH -mm] 0/2: PCI MMCONFIG-related updates
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <465CF712.2010604@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches implement some changes in behavior related to PCI
MMCONFIG configuration space access. One changes the way in which we
validate the MCFG table provided by the BIOS by checking it against
ACPI motherboard resources instead of the E820 table. The BIOS is not
required to reserve this area in the E820 table, so checking that
results in MMCONFIG being unnecessarily disabled on some machines.

Some Intel chipsets where MMCONFIG was being disabled previously
(but won't be with the first patch) had problems, not due to the
MCFG table being broken, but because the access was hosed by the way
in which we do PCI BAR sizing. The second patch fixes this problem.

This is requested for inclusion in the -mm tree for testing.

