Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbZKLAZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbZKLAZG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 19:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759737AbZKLAZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 19:25:05 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:15745 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbZKLAZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 19:25:04 -0500
Subject: [PATCH 0/2] Fix cciss/hpsa build errors
To: akpm@linux-foundation.org, jens.axboe@oracle.com
From: Alex Chiang <achiang@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mike Miller <mikem@beardog.cce.hp.com>, linux-kernel@vger.kernel.org,
       "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Date: Wed, 11 Nov 2009 17:25:07 -0700
Message-ID: <20091112001933.5660.10843.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently tried to build mmotm, and configured both hpsa and cciss
as built-ins. I encountered the following build error since they
both export device attrs with the same name:

	drivers/scsi/built-in.o: multiple definition of `dev_attr_lunid'
	drivers/block/built-in.o: first defined here

The cciss patch seems obviously correct to me and would be appropriate
for the next .32-rc. But it's not critical, so if Jens wants to hold off
until next merge window, I'm fine with that.

The hpsa patch applies against mmotm. I haven't peeked at James's tree
to see if he's carrying hpsa, but my guess is "probably not". In that
case, I'm hoping Andrew can carry it until hpsa gets merged.

Thanks,
/ac

---

Alex Chiang (2):
      cciss: make device attrs static
      hpsa: make device attrs static


 drivers/block/cciss.c |   16 ++++++++--------
 drivers/scsi/hpsa.c   |    8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

