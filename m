Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbZA0Fub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbZA0Fub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZA0FuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:50:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56693 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZA0FuW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:50:22 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH] make checkpatch warn about access to current->comm
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20090127053920.GB5034@bombadil.infradead.org>
References: <20090126212918.d4770115.akpm@linux-foundation.org> <20090127053920.GB5034@bombadil.infradead.org>
Message-Id: <20090128144316.D467.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 27 Jan 2009 14:50:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +# direct access to current task name is racy, suggest accessor instead.
> +		if ($line =~ /current\-\>comm/) {
> +			WARN("direct access to current->comm is racy, use get_task_comm() instead.\n" . $herecurr);
> +		}
> +
>  # use of NR_CPUS is usually wrong
>  # ignore definitions of NR_CPUS and usage to define arrays as likely right
>  		if ($line =~ /\bNR_CPUS\b/ &&


./scripts/checkpatch --file fs/exec.c
------------------------------------------------------
WARNING: direct access to current->comm is racy, use get_task_comm() instead.
#952: FILE: exec.c:952:
+       char tcomm[sizeof(current->comm)];

(snip)

WARNING: direct access to current->comm is racy, use get_task_comm() instead.
#1459: FILE: exec.c:1459:
+                                             "%s", current->comm);

(snip)

WARNING: direct access to current->comm is racy, use get_task_comm() instead.
#1788: FILE: exec.c:1788:
+               if (!strcmp(delimit, current->comm)) {

---------------------------

I think "char tcomm[sizeof(current->comm)];" is valid code.
if checkpatch.pl don't warn "sizeof(current->comm)", I'm glad.



