Return-Path: <linux-kernel-owner+w=401wt.eu-S940398AbXGTQDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940398AbXGTQDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbXGTQDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:03:01 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44140 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934489AbXGTQC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:02:58 -0400
Date: Fri, 20 Jul 2007 09:02:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] compacting file_ra_state
In-Reply-To: <384933499.09699@ustc.edu.cn>
Message-ID: <alpine.LFD.0.999.0707200858270.27249@woody.linux-foundation.org>
References: <20070720100740.106917381@mail.ustc.edu.cn> <384926279.42287@ustc.edu.cn>
 <p73y7hbux4d.fsf@bingen.suse.de> <384933499.09699@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jul 2007, Fengguang Wu wrote:

> On Fri, Jul 20, 2007 at 01:34:42PM +0200, Andi Kleen wrote:
> > 
> > This would add a new limit to 64bit architectures.  Surely keeping
> > start at pgoff_t will not be a big issue? The other fields can be
> > 32bit.
> 
> Yeah, it counts for about 4MB memory for 1M opened files.

I'd suggest keeping "start" as pgoff_t, and doing what Peter Zijlstra 
suggested about prev_offset / prev_index and turning that combination into 
a "loff_t". The latter will cause some more 64-bit operations, but by now 
I think we can start thinking of 64 bits as the norm, and it will be more 
logical, methinks.

Then, when/if we add a config option to turn pgoff_t into a 32-bit entry 
for us normal people who think that 16TB is plenty (and would rather have 
smaller and faster harddisks than go beyond it), that will also solve the 
"start" issue.

Does that sound like a plan?

So I'm going to ignore the current series in the hopes that we'll have a 
new one soon enough.

			Linus
