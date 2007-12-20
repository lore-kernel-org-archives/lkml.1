Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbXLTBeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbXLTBeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbXLTBeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:11604 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbXLTBeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=IQPBDomQGyr5Bikvi8U2njhmNXn08jtFQbi9o859L7VgELyxUQwR/mkTokAIWHUs3huvot7OkdKsV6smoENBqfZiUwQx4TzJWn+JlPh2b7lBvDZTKjwSKnGfk5E1HTdrjQffcDtppqKtXo5T8WJtHOTtkDkhKl6/w1Z/2BfGlZo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 00/63] ide-cd: redux
Date: Thu, 20 Dec 2007 01:48:49 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712200148.49690.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This patch series is a major rework of the ide-cd driver.

The motivations behind it are twofold:

* ide-cd is still in use but because it has been out of luck for maintainers
  lately the code become quite hard to debug and maintain - this puts it back
  into the shape

* aid efforts of developers (Tejun and Alan) who are working on libata ATAPI
  support - it should be now a lot easier to spot the various quirks for
  weird/buggy devices, differences between sr/ide-cd etc.

This patch series contains only safe/straightforward changes (some "risky"
ones are scheduled for later time) and should be fully bisectable.


Changes:

* unify _four_ slightly different IRQ handlers into one

* re-organize handling of quirky-devices (group quirks scattered
  all over the driver in the table and handle them using flags)

* move code for verbose error logging to ide-cd_verbose.c (this
  code doesn't have any IDE subsystem dependencies so if desired
  it can be easily converted into generic IDE/libata library)

* move code handling cdrom.c IOCTLs to ide-cd_ioctl.c

* remove duplicated/dead code (> 700 LOC gone)

* move historical changelog to Documentation/ide/

* fix few bugs discovered during rewrite


diffstat:

 Documentation/ide/ChangeLog.ide-cd.1994-2004 |  268 ++
 drivers/cdrom/cdrom.c                        |    6
 drivers/ide/Kconfig                          |    9
 drivers/ide/Makefile                         |    6
 drivers/ide/ide-cd.c                         | 3236 +++++++++------------------
 drivers/ide/ide-cd.h                         |  737 ------
 drivers/ide/ide-cd_ioctl.c                   |  265 ++
 drivers/ide/ide-cd_verbose.c                 |  359 ++
 include/linux/cdrom.h                        |   14
 9 files changed, 2095 insertions(+), 2805 deletions(-)


PS ide-cd Maintainer position is still open...

Thanks,
Bart
