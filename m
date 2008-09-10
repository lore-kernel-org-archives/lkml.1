Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbYIJDYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbYIJDYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYIJDYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:24:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52362 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYIJDYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:24:07 -0400
Date: Tue, 9 Sep 2008 21:19:41 -0600
From: Pete Zaitcev <zaitcev@redhat.com>
To: <jdmason@kudzu.us>, <muli@il.ibm.com>
Cc: zaitcev@redhat.com, linux-kernel@vger.kernel.org
Subject: Calgary and bad_dma_address
Message-Id: <20080909211941.0a0fda6a.zaitcev@redhat.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, guys:

I was reading arch/x86/kernel/pci-calgary_64.c today, and noticed that
apparently nothing prevents iommu_area_alloc from returning a zero.
But bad_dma_address is zero too. Doesn't it concern anyone?
If the first allocation asks for a page-aligned buffer to be mapped,
a spurious bad address will result, if I understand this right.

The simplest way to avoid the problem is to lose a page and set a bit
in tce_table_setparms():
   set_bit(tbl->it_map, bad_dma_address);
But I don't see anything like that done anywhere.

-- Pete
