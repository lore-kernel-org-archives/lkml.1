Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZIQHXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZIQHXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758749AbZIQHW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:22:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702AbZIQHW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:22:58 -0400
Date: Thu, 17 Sep 2009 10:20:57 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com
Subject: [PATCHv3 0/2] mm: use_mm/unuse_mm
Message-ID: <20090917072056.GA18115@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves use_mm/unuse_mm from aio into mm, and optimizes atomic usage
there. Original patchset also exported use_mm/unuse_mm to modules, for
use by vhost, that bit will come in later when vhost is posted for
inclusion.

Michael S. Tsirkin (2):
  mm: move use_mm/unuse_mm from aio.c to mm/
  mm: reduce atomic use on use_mm fast path

 fs/aio.c                    |   47 +----------------------------------
 include/linux/mmu_context.h |    9 ++++++
 mm/Makefile                 |    2 +-
 mm/mmu_context.c            |   58 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 47 deletions(-)
 create mode 100644 include/linux/mmu_context.h
 create mode 100644 mm/mmu_context.c
