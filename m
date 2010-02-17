Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447Ab0BQCTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:19:53 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42352 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174Ab0BQCTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:19:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002161648570.31753@chino.kir.corp.google.com> <alpine.DEB.2.00.1002161756100.15079@chino.kir.corp.google.com>
Message-Id: <20100217111659.7324.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 17 Feb 2010 11:19:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * The pagefault handler calls here because it is out of memory, so kill a
> + * memory-hogging task.  If a populated zone has ZONE_OOM_LOCKED set, a parallel
> + * oom killing is already in progress so do nothing.  If a task is found with
> + * TIF_MEMDIE set, it has been killed so do nothing and allow it to exit.
> + */
> +void pagefault_out_of_memory(void)
> +{
> +	if (!try_set_system_oom())
> +		return;
> +	out_of_memory(NULL, 0, 0, NULL);
> +	clear_system_oom();
> +}

At least, I agree pagefault oom part. it need ZONE_OOM_LOCKED too.
if you make separated patch, I'll ack it. I don't know memcg part is 
correct or not.



