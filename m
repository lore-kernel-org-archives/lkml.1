Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966335Ab0BZV57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 16:57:59 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:33477 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966217Ab0BZV55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 16:57:57 -0500
Subject: [PATCH 0/9] cciss driver SCSI updates 
To: axboe@kernel.dk, akpm@linux-foundation.org, james.bottomley@suse.de
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com,
       linux-scsi@vger.kernel.org, brace@beardog.cce.hp.com
Date: Fri, 26 Feb 2010 16:01:06 -0600
Message-ID: <20100226220023.11979.4999.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series mainly fixes the scsi tape code in the cciss
driver to take advantage of more scatter gather elements, enabling
larger transfer sizes.  The first eight patches are mainly cleaning
things up and getting ready for the 9th patch, which enables the
SCSI half of the driver to use more than 31 scatter gather elements.

I've tested on 32-bit and 64-bit systems, and written out tapes
with block sizes up to 2Mb.

These patches are vs. Jens's linux-2.6-block tree.

Stephen M. Cameron (9):
      cciss: clarify command list padding calculation
      cciss: detect bad alignment of scsi commands at build time
      cciss: factor out scatter gather chain block allocation and freeing
      cciss: simplify scatter gather code
      cciss: fix scatter gather chain block dma direction kludge
      cciss: factor out scatter gather chain block mapping code
      cciss: do not use void pointer for scsi hba data
      cciss: eliminate unnecessary pointer use in cciss scsi code
      cciss: Fix problem with scatter gather elements in the scsi half of the driver


 drivers/block/cciss.c      |  174 ++++++++++++++++++++++----------------------
 drivers/block/cciss.h      |   12 +--
 drivers/block/cciss_cmd.h  |   14 +++-
 drivers/block/cciss_scsi.c |  145 +++++++++++++++++++++++--------------
 4 files changed, 188 insertions(+), 157 deletions(-)

-- 
-- steve

