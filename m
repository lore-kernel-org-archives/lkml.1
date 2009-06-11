Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbZFKOy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbZFKOy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761466AbZFKOx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:53:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:31949 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761647AbZFKOxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:53:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="153176986"
Message-Id: <20090611142239.192891591@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Jun 2009 22:22:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
cc: Nick Piggin <npiggin@suse.de>
CC: Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: [PATCH 0/5] [RFC] HWPOISON incremental fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here are the hwpoison fixes that aims to address Nick and Hugh's concerns.
Note that
- the early kill option is dropped for .31. It's obscure option and complex
  code and is not must have for .31. Maybe Andi also aims this option for
  notifying KVM, but right now KVM is not ready to handle that.
- It seems that even fsync() processes are not easy to catch, so I abandoned
  the SIGKILL on fsync() idea. Instead, I choose to fail any attempt to
  populate the poisoned file with new pages, so that the corrupted page offset
  won't be repopulated with outdated data. This seems to be a safe way to allow
  the process to continue running while still be able to promise good (but not
  complete) data consistency.
- I didn't implement the PANIC-on-corrupted-data option. Instead, I guess
  sending uevent notification to user space will be a more flexible scheme?

Thanks,
Fengguang
-- 

