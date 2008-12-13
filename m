Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYLMXjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYLMXjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 18:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbYLMXjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 18:39:43 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63262 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbYLMXjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 18:39:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=nrAZYdwVs+aL3DNPyFO0pui4+vO+mQ+TN9803STp7FR+6EPnOrAav7CygchTdU36Qr
         XiGNRXpdniY3HzAls+2ykFh2UaDKMMOOOXUE9UKLuggvDPZ+UdIEJTSIvAZq6aPKNq4f
         MT4zU5KjRrhBFJm29g0KHPDeUN6I0gDidBSow=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2008 00:39:25 +0100
Message-Id: <20081213233925.4653.58008.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/6] ide: final bits of struct hwgroup_s -> struct ide_host change
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In the process we fix years old bug, improve the locking for serialized ports
(making it simpler to grasp and more efficient at the same time) and simplify
the core IDE code significantly...

diffstat:
 drivers/ide/alim15x3.c     |    2 
 drivers/ide/au1xxx-ide.c   |    6 
 drivers/ide/icside.c       |    2 
 drivers/ide/ide-atapi.c    |    8 -
 drivers/ide/ide-cd.c       |   16 +-
 drivers/ide/ide-dma-sff.c  |    4 
 drivers/ide/ide-dma.c      |    2 
 drivers/ide/ide-floppy.c   |    2 
 drivers/ide/ide-io.c       |  297 +++++++++++++++++++++------------------------
 drivers/ide/ide-iops.c     |   67 ++++------
 drivers/ide/ide-lib.c      |    9 -
 drivers/ide/ide-park.c     |   16 +-
 drivers/ide/ide-pm.c       |    2 
 drivers/ide/ide-probe.c    |  198 ++++--------------------------
 drivers/ide/ide-tape.c     |    9 -
 drivers/ide/ide-taskfile.c |    4 
 drivers/ide/ide.c          |   24 ---
 drivers/ide/pdc202xx_old.c |    2 
 drivers/ide/pmac.c         |    2 
 drivers/ide/scc_pata.c     |    4 
 drivers/ide/sgiioc4.c      |    2 
 drivers/ide/tc86c001.c     |   10 -
 drivers/ide/trm290.c       |    2 
 drivers/ide/tx4939ide.c    |    2 
 drivers/ide/umc8672.c      |   13 -
 include/linux/ide.h        |  107 +++++-----------
 26 files changed, 299 insertions(+), 513 deletions(-)
