Return-Path: <linux-kernel-owner+w=401wt.eu-S933588AbZJFWaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbZJFWaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933462AbZJFWaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:30:06 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:61852 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305AbZJFWaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DHrLvnIjPWZp/FE1vYIyNONhLmm8wfdNW15JnoM6FGX3Aq6qvckmFWWzpmLRQSU3fp
         YTXGl3puXgSV2AfgPK6uzh5k5TvK2HPDjzoaH6CjxmhNW5sNlPRS+YOED8UEPrOpVDE9
         xMNEkpOPKWrj1zqeqoTGYfhD3fIWKKqVIhCTc=
Date: Wed, 7 Oct 2009 00:29:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH v2] perf tools: Start the perf.data mapping at data
	offset in perf trace
Message-ID: <20091006222924.GA11007@nowhere>
References: <1254856626-10286-1-git-send-email-fweisbec@gmail.com> <1254856886-10348-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254856886-10348-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 09:21:26PM +0200, Frederic Weisbecker wrote:
> Currently, we are mapping perf.data in the beginning of the file
> and use the data offset as a buffer offset. This may exceed the
> mapping area if the data offset is upper than page_size * mmap_window
> and result in a page fault (thing that happen if we merge trace.info
> in perf.data).
> 
> Instead, let's start the mapping in the page that matches our data
> offset.
> 
> v2: Drop a junk from another patch (trace_report() removal)
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Tom Zanussi <tzanussi@gmail.com>


I just tested the trace.info drop with perf sched, and we have the same bug
with mmap.

I guess we should rather have a common helper to use mmap on perf.data
and rely on a callback to process the events.
I'm putting this in my TODO list.

