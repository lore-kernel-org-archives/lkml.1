Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbZB1ILM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbZB1ILM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 03:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZB1IK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 03:10:57 -0500
Received: from mail.openmoko.org ([88.198.124.205]:38999 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZB1IK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 03:10:57 -0500
Subject: [PATCH 0/2] spi: Add support for non-blocking synchronous transfers
To: linux-kernel@vger.kernel.org
From: Balaji Rao <balajirrao@openmoko.org>
Cc: spi-devel-general@lists.sourceforge.net, Andy Green <andy@openmoko.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Date: Sat, 28 Feb 2009 13:40:36 +0530
Message-ID: <20090228081036.31964.80618.stgit@fedora.yogi>
User-Agent: StGit/0.14.3.343.g0584
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During the course of development of an accelerometer driver, we saw the
necessity to execute spi transfers synchronously within an interrupt handler.
When using a workqueue instead, we observed a huge number of overruns with very
high cpu utlization, which is unacceptable.

This series adds a new interface for this and modifies no existing ones.

[PATCH 1/2] - Adds synchronous non-blocking transfer support to spi core
[PATCH 2/2] - Implements this support in spi_bitbang.c


Balaji Rao (2):
      spi_bitbang: Add support for non-blocking synchronous transfers
      spi: Add support for non-blocking synchronous transfers


 drivers/spi/spi_bitbang.c       |  227 +++++++++++++++++++++------------------
 include/linux/spi/spi.h         |   31 +++++
 include/linux/spi/spi_bitbang.h |    5 +
 3 files changed, 156 insertions(+), 107 deletions(-)


--
Balaji Rao
