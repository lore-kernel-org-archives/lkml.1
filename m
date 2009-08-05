Return-Path: <linux-kernel-owner+w=401wt.eu-S934005AbZHEKSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005AbZHEKSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbZHEKSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:18:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50570 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933243AbZHEKSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:18:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 5 Aug 2009 19:16:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de, hugh.dickins@tiscali.co.uk,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: [PATCH] ZERO_PAGE again v5.
Message-Id: <20090805191643.2b11ae78.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Updated from v4 as
  - avoid to add new arguments to vm_normal_page().
    vm_normal_page() always returns NULL if ZERO_PAGE is found.
  - follow_page() directly handles pte_special and ANON_ZERO_PAGE.

Then, amount of changes are reduced. Thanks for advices.

Concerns pointed out:
  - Does use_zero_page() cover all cases ?
    I think yes..
  - All get_user_pages() callers, which may find ZERO_PAGE is safe ?
    need tests.
  - All follow_pages() callers, which may find ZERO_PAGE is safe ?
    I think yes.

Thanks,
-Kame

