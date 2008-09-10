Return-Path: <linux-kernel-owner+w=401wt.eu-S1752014AbYIJGHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbYIJGHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 02:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYIJGHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 02:07:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbYIJGHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 02:07:18 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
X-Fcc: ~/Mail/linus
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh@veritas.com>, William Irwin <wli@holomorphy.com>,
       Adam Litke <agl@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH] coredump_filter: add hugepage core dumping
In-Reply-To: Hidehiro Kawai's message of  Monday, 8 September 2008 10:51:28 +0900 <48C48520.9070206@hitachi.com>
References: <20080828142352.6ABC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080902134850.GA26372@csn.ul.ie>
	<48C48520.9070206@hitachi.com>
X-Windows: you'd better sit down.
Message-Id: <20080910060431.188081541FE@magilla.localdomain>
Date: Tue,  9 Sep 2008 23:04:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was certainly not meant to be excluded from any documentation.  

To make the description clear, MMF_DUMP_ELF_HEADERS applies when a
file-backed private mapping would otherwise be elided (based on the other
bits and whether it's been modified).  If the vma maps offset 0 of the
file, and that page is readable and starts with ELFMAG, then just that
first page will be dumped.  (So p_filesz will be PAGE_SIZE rather than 0
for an elided mapping, or p_memsz for a mapping dumped whole.)


Thanks,
Roland
