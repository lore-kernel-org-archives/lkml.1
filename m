Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbXEGEqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbXEGEqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 00:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXEGEqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 00:46:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbXEGEqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 00:46:12 -0400
Message-ID: <463EB169.8030701@redhat.com>
Date: Mon, 07 May 2007 00:56:09 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au> <463E5A00.6070708@redhat.com> <463E921D.3070407@redhat.com>
In-Reply-To: <463E921D.3070407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Rik van Riel wrote:
>> I think that maybe for 2.6.22 we should just alias MADV_FREE
>> to run with the MADV_DONTNEED functionality, so that the glibc
>> people can make the change on their side while we figure out
>> what will be the best thing to do on the kernel side.
> 
> No need for that.  We can later extend glibc to use MADV_FREE and fall 
> back on MADV_DONTNEED.

It's trivial to merge the MADV_FREE #defines into the kernel
though, and aliasing MADV_FREE to MADV_DONTNEED for the time
being is a one-liner - just an extra constant into the big
switch statement in sys_madvise().

