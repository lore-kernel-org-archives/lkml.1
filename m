Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbZLOAuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbZLOAuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 19:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbZLOAuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 19:50:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57731 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZLOAut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 19:50:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 8/8] mm: Give up allocation if the task have fatal signal
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091215085455.13eb65cc.minchan.kim@barrios-desktop>
References: <20091214213224.BBC6.A69D9226@jp.fujitsu.com> <20091215085455.13eb65cc.minchan.kim@barrios-desktop>
Message-Id: <20091215094659.CDB8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 15 Dec 2009 09:50:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  	/*
> > +	 * If the allocation is for userland page and we have fatal signal,
> > +	 * there isn't any reason to continue allocation. instead, the task
> > +	 * should exit soon.
> > +	 */
> > +	if (fatal_signal_pending(current) && (gfp_mask & __GFP_HIGHMEM))
> > +		goto nopage;
> 
> If we jump nopage, we meets dump_stack and show_mem. 
> Even, we can meet OOM which might kill innocent process.

Which point you oppose? noprint is better?


