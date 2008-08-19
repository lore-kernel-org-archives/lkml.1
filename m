Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbYHSAOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbYHSAOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 20:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbYHSAN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 20:13:57 -0400
Received: from styx.suse.cz ([82.119.242.94]:46430 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753001AbYHSAN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 20:13:56 -0400
Date: Tue, 19 Aug 2008 02:13:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       Leo Duran <leo.duran@amd.com>
Subject: [PATCH] x86 iommu: remove unneeded parenthesis
Message-ID: <alpine.LNX.1.10.0808190211060.18058@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parenthesis in __iommu_queue_command() are not needed when assigning 
into 'target' variable.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index de39e1f..69b4d06 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -65,7 +65,7 @@ static int __iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
  	u8 *target;

  	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
-	target = (iommu->cmd_buf + tail);
+	target = iommu->cmd_buf + tail;
  	memcpy_toio(target, cmd, sizeof(*cmd));
  	tail = (tail + sizeof(*cmd)) % iommu->cmd_buf_size;
  	head = readl(iommu->mmio_base + MMIO_CMD_HEAD_OFFSET);
