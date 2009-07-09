Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbZGID0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbZGID0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbZGID02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:26:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44917 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090AbZGID02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:26:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 9 Jul 2009 12:24:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-mm@kvack.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       avi@redhat.com, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, aarcange@redhat.com
Subject: [PATCH 0/2] ZERO PAGE again v3.
Message-Id: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After v2 discussion, I felt that "Go" sign can be given if implemetaion is neat
and tiny and overhead seems very small. Here is v3.

In this version,

 - use pte_special() in vm_normal_page()
   All ZERO_PAGE check will go down to vm_normal_page() and check is done here.
   Some new flags in follow_page() and get_user_pages().

 - per arch use-zero-page config is added.
   IIUC, archs which have _PAGE_SPECIAL is only x86, powerpc, s390.
   Because this patch make use of pte_special() check, config to use zero page
   is added and you can turn it off if necessary.
   I this patch, only x86 is turned on which I can test.

Any comments are welcome. 

Thanks,
-Kame

