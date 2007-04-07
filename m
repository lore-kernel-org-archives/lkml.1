Return-Path: <linux-kernel-owner+w=401wt.eu-S965760AbXDGLU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965760AbXDGLU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 07:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965763AbXDGLU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 07:20:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965760AbXDGLUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 07:20:25 -0400
Date: Sat, 7 Apr 2007 07:18:49 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Ulrich Drepper <drepper@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       "Shai Fultheim (Shai@scalex86.org)" <shai@scalex86.org>,
       pravin b shelar <pravin.shelar@calsoftinc.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH, take4] FUTEX : new PRIVATE futexes
Message-ID: <20070407111849.GT355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20060808070708.GA3931@localhost.localdomain> <200608090826.28249.dada1@cosmosbay.com> <200608090843.52893.dada1@cosmosbay.com> <200703152010.35614.dada1@cosmosbay.com> <a36005b50704040016l180f397bwe5a05e8bf78013b0@mail.gmail.com> <20070405194942.1414c030.dada1@cosmosbay.com> <20070407104339.6674336b.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407104339.6674336b.dada1@cosmosbay.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 10:43:39AM +0200, Eric Dumazet wrote:
> get_futex_key() does a check against sizeof(u32) regardless of futex being 64bits or not.
> So it is possible a 64bit futex spans two pages of memory...

That would be a user bug.  32-bit futexes have to be 32-bit aligned, 64-bit
futexes have to be 64-bit aligned.

	Jakub
