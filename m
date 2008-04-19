Return-Path: <linux-kernel-owner+w=401wt.eu-S1759931AbYDSKEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931AbYDSKEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYDSKEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:04:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58525 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYDSKE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:04:29 -0400
Date: Sat, 19 Apr 2008 19:04:30 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Matt Mackall" <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>, dev-etrax@axis.com,
       "Luck, Tony" <tony.luck@intel.com>,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: [PATCH][trivial][0/2] mm/pagewalk.c break const constraint. take2
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080419184918.A8EE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <19f34abd0804190234m190f7ec4ga2a652029a83bab6@mail.gmail.com> <20080419184918.A8EE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080419185723.A8F1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch is against 2.6.25


when compile 2.6.25 on ia64, following warnings was outputed.

  CC      mm/pagewalk.o
mm/pagewalk.c: In function 'walk_page_range':
mm/pagewalk.c:111: warning: passing argument 1 of 'pgd_offset' discards qualifiers from p\
ointer target type

the type of mm argument of walk_page_range() is "const struct mm *",
but pgd_offset() on ia64 declare "struct mm*".
cris port has the same problems.

I propse add const to pgd_offset() for solve this problem.

Thanks!


