Return-Path: <linux-kernel-owner+w=401wt.eu-S1758935AbZLOBJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758935AbZLOBJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbZLOBJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:09:16 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:65266 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758417AbZLOBJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=SuP2b4njptYmjM6rdyFEmo3nOIYDdgGV3ZWJwLlk0dzHf+Rbnc/L5uPahCC0UnB9W1
         ax861dJCaOhW/y/7sZyixrhF02b7L2CLggPJBZVQQvQNNVpykdgA5SSsX4Es0rZwSyBt
         pX385179HuuFjdZ81jSzUmV5H5zi9R8QUZ4k4=
Date: Tue, 15 Dec 2009 10:03:42 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       lwoodman@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] mm: Give up allocation if the task have fatal
 signal
Message-Id: <20091215100342.e77c8cbe.minchan.kim@barrios-desktop>
In-Reply-To: <20091215094659.CDB8.A69D9226@jp.fujitsu.com>
References: <20091214213224.BBC6.A69D9226@jp.fujitsu.com>
	<20091215085455.13eb65cc.minchan.kim@barrios-desktop>
	<20091215094659.CDB8.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Dec 2009 09:50:47 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > >  	/*
> > > +	 * If the allocation is for userland page and we have fatal signal,
> > > +	 * there isn't any reason to continue allocation. instead, the task
> > > +	 * should exit soon.
> > > +	 */
> > > +	if (fatal_signal_pending(current) && (gfp_mask & __GFP_HIGHMEM))
> > > +		goto nopage;
> > 
> > If we jump nopage, we meets dump_stack and show_mem. 
> > Even, we can meet OOM which might kill innocent process.
> 
> Which point you oppose? noprint is better?
> 
> 

Sorry fot not clarity.
My point was following as. 

First,
I don't want to print.
Why do we print stack and mem when the process receives the SIGKILL?

Second, 
1) A process try to allocate anon page in do_anonymous_page.
2) A process receives SIGKILL.
3) kernel doesn't allocate page to A process by your patch.
4) do_anonymous_page returns VF_FAULT_OOM.
5) call mm_fault_error
6) call out_of_memory 
7) It migth kill innocent task. 

If I missed something, Pz, corret me. :)

-- 
Kind regards,
Minchan Kim
