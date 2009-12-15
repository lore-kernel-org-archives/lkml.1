Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbZLOBQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbZLOBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758931AbZLOBQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:16:57 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52214 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533AbZLOBQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:16:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 8/8] mm: Give up allocation if the task have fatal signal
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091215100342.e77c8cbe.minchan.kim@barrios-desktop>
References: <20091215094659.CDB8.A69D9226@jp.fujitsu.com> <20091215100342.e77c8cbe.minchan.kim@barrios-desktop>
Message-Id: <20091215101512.CDC4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 15 Dec 2009 10:16:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 15 Dec 2009 09:50:47 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > >  	/*
> > > > +	 * If the allocation is for userland page and we have fatal signal,
> > > > +	 * there isn't any reason to continue allocation. instead, the task
> > > > +	 * should exit soon.
> > > > +	 */
> > > > +	if (fatal_signal_pending(current) && (gfp_mask & __GFP_HIGHMEM))
> > > > +		goto nopage;
> > > 
> > > If we jump nopage, we meets dump_stack and show_mem. 
> > > Even, we can meet OOM which might kill innocent process.
> > 
> > Which point you oppose? noprint is better?
> > 
> > 
> 
> Sorry fot not clarity.
> My point was following as. 
> 
> First,
> I don't want to print.
> Why do we print stack and mem when the process receives the SIGKILL?
> 
> Second, 
> 1) A process try to allocate anon page in do_anonymous_page.
> 2) A process receives SIGKILL.
> 3) kernel doesn't allocate page to A process by your patch.
> 4) do_anonymous_page returns VF_FAULT_OOM.
> 5) call mm_fault_error
> 6) call out_of_memory 
> 7) It migth kill innocent task. 
> 
> If I missed something, Pz, corret me. :)

Doh, you are complely right. I had forgot recent meaning change of VM_FAULT_OOM.
yes, this patch is crap. I need to remake it.



