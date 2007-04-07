Return-Path: <linux-kernel-owner+w=401wt.eu-S965695AbXDGKBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965695AbXDGKBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 06:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965711AbXDGKBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 06:01:20 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:57162 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965695AbXDGKBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 06:01:18 -0400
Date: Sat, 7 Apr 2007 12:00:51 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
Message-Id: <20070407120051.9ed0e69a.dada1@cosmosbay.com>
In-Reply-To: <461764A6.3080703@yahoo.com.au>
References: <20060808070708.GA3931@localhost.localdomain>
	<200608090826.28249.dada1@cosmosbay.com>
	<200608090843.52893.dada1@cosmosbay.com>
	<200703152010.35614.dada1@cosmosbay.com>
	<a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com>
	<20070405194942.1414c030.dada1@cosmosbay.com>
	<20070407104339.6674336b.dada1@cosmosbay.com>
	<461764A6.3080703@yahoo.com.au>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 07 Apr 2007 12:00:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Apr 2007 19:30:14 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Eric Dumazet wrote:
 
> > 
> > - Current mm code have a problem with 64bit futexes, as spoted by Nick :
> > 
> > get_futex_key() does a check against sizeof(u32) regardless of futex being 64bits or not.
> > So it is possible a 64bit futex spans two pages of memory...
> > I had to change get_futex_key() prototype to be able to do a correct test.
> 
> I wonder if it should be encfocing alignment to keep in on 1 page?

I believe I just did that :)

Before the patch :

Alignment was only 4 bytes for all futexes, but some user app could trigger a kernel bug (since one 64bit futex could sit on two different pages, so possible separate vmas, so the inode refcounting was wrong, and access_ok did not a correct check)

After the patch :

Alignment is 8 bytes for 64 bit futexes, 4 bytes for 32bit futexes.
All futexes are contrained to be in one single page.

