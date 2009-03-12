Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZCLIgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZCLIgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbZCLIgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:36:41 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42790 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZCLIgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:36:40 -0400
Message-ID: <49B8C98D.3020309@davidnewall.com>
Date: Thu, 12 Mar 2009 19:06:29 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       bug-tar@gnu.org
Subject: Re: I just got got another Oops
References: <200903120133.11583.gene.heskett@gmail.com>
In-Reply-To: <200903120133.11583.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Mar 12 01:15:01 coyote xinetd[2583]: START: amanda pid=8970 from=::ffff:192.168.71.3                                                     
> Mar 12 01:16:21 coyote kernel: [10353.910914] BUG: unable to handle kernel NULL pointer dereference at 00000006
> Mar 12 01:16:21 coyote kernel: [10353.910921] IP: [<c046520b>] get_page_from_freelist+0x24b/0x4c0
> Mar 12 01:16:21 coyote kernel: [10353.910929] *pdpt = 0000000000b38001 *pde = 0000000000000000
> Mar 12 01:16:21 coyote kernel: [10353.910934] Oops: 0000 [#1] PREEMPT SMP

I think there must be a zone at 0x0.  Try adding

		if (!zone) goto try_next_zone;


in mm/page_alloc.c, (near line 1469), before

		if (NUMA_BUILD && zlc_active &&

