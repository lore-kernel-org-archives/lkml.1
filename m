Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab0BJUhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 15:37:38 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61548 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0BJUhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 15:37:35 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5888"; a="33877069"
From: adharmap@codeaurora.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
Date: Wed, 10 Feb 2010 12:37:28 -0800
Message-Id: <1265834250-29170-1-git-send-email-adharmap@codeaurora.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijeet Dharmapurikar <adharmap@quicinc.com>

Please refer to the post here
http://lkml.org/lkml/2010/1/4/347

These changes are to introduce barrierless dma_map_area and dma_unmap_area and
use them to map the buffers in the scatterlist. For the last buffer, call
the normal dma_map_area(aka with barriers) effectively executing the barrier
at the end of the operation.

Note that the barrierless operations are implemented for few arm
architectures only and I would implement for others once these are okayed by the
community.

Abhijeet Dharmapurikar (2):
  dma: define barrierless versions of map and unmap area
  dma: fix scatter-gather api to use barrierless map/unmap functions

 arch/arm/include/asm/cacheflush.h  |    9 +++
 arch/arm/include/asm/dma-mapping.h |   82 +++++++++++++++++++++
 arch/arm/mm/cache-v3.S             |    6 ++
 arch/arm/mm/cache-v4.S             |    6 ++
 arch/arm/mm/cache-v4wb.S           |   94 +++++++++++++++++-------
 arch/arm/mm/cache-v4wt.S           |    6 ++
 arch/arm/mm/cache-v6.S             |  139 +++++++++++++++++++++++++----------
 arch/arm/mm/cache-v7.S             |  120 +++++++++++++++++++++++--------
 arch/arm/mm/dma-mapping.c          |   55 +++++++++++++--
 9 files changed, 414 insertions(+), 103 deletions(-)

