Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbXKBBSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbXKBBSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 21:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbXKBBSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 21:18:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33854 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754060AbXKBBSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 21:18:40 -0400
Date: Thu, 1 Nov 2007 18:17:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
 causes unkillable spinning
In-Reply-To: <20071101235644.GA20144@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0711011816260.3342@woody.linux-foundation.org>
References: <20071031041932.GA12189@wotan.suse.de>
 <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org>
 <20071031151934.GA19211@wotan.suse.de> <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org>
 <20071031225541.GA28552@wotan.suse.de> <alpine.LFD.0.999.0710311602170.3342@woody.linux-foundation.org>
 <20071101023758.GA30613@wotan.suse.de> <alpine.LFD.0.999.0711010809171.3342@woody.linux-foundation.org>
 <20071101154705.GA745@wotan.suse.de> <alpine.LFD.0.999.0711010901290.3342@woody.linux-foundation.org>
 <20071101235644.GA20144@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Nov 2007, Nick Piggin wrote:
> 
> But we do want to allow forced COW faults for MAP_PRIVATE mappings. gdb
> uses this for inserting breakpoints (but fortunately, a COW page in a
> MAP_PRIVATE mapping is a much more natural thing for the VM).

Yes, I phrased that badly. I meant that I'd be happier if we got rid of 
VM_MAYSHARE entirely, and just used VM_SHARED. I thought we already made 
them always be the same (and any VM_MAYSHARE use is historical).

		Linus
