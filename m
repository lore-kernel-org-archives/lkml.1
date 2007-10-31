Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbXJaXIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbXJaXIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 19:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXJaXIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 19:08:47 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35430 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbXJaXIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 19:08:46 -0400
Date: Wed, 31 Oct 2007 16:08:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
 causes unkillable spinning
In-Reply-To: <20071031225541.GA28552@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0710311602170.3342@woody.linux-foundation.org>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
 <20071031041932.GA12189@wotan.suse.de> <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org>
 <20071031151934.GA19211@wotan.suse.de> <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org>
 <20071031225541.GA28552@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Oct 2007, Nick Piggin wrote:
> 
> No that would be great. Fingers crossed it won't cause any problems.

I actually doubt it will cause problems.

We made much bigger changes to ptrace support when we disallowed writing 
to read-only shared memory areas (we used to do the magic per-page COW 
thing).

But if people have test-cases for ptrace and/or other magical users of 
access_vm_pages() (things like core-dumping comes to mind - although I 
think we don't dump pure file mappings at all, do we?) it would certainly 
be good to run any such tests on the current -git tree...

		Linus
