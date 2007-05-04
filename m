Return-Path: <linux-kernel-owner+w=401wt.eu-S1423072AbXEDXsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423072AbXEDXsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423135AbXEDXsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:48:21 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:23955 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423120AbXEDXsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:48:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=R6Ecl8HwGKlPLe91eQdFtLPs3sGDIviCn2gnkN2yva42R1FahfhzG3TNQa5LOrSF9FSkahric1flDPCW5M2U5eerXg4GEeglFKKce9iHTC9z0+qY9kUyoc3CKORpaXezbeHQVeqKGNskIT4rYoisg1QpP7CD/UQrm9T6Xmini48=  ;
X-YMail-OSG: ELCCVaMVM1kP8jlZxqedu8f6bdNNWKL.H5P7j8RsgBUW.fRTInGjP.vvocBhckqqEZ9UOLog7g--
Message-ID: <463BC62C.3060605@yahoo.com.au>
Date: Sat, 05 May 2007 09:47:56 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com>
In-Reply-To: <463B598B.80200@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> Nick Piggin wrote:
> 
>>What I found is that, on this system, MADV_FREE performance improvement
>>was in the noise when you look at it on top of the MADV_DONTNEED glibc
>>and down_read(mmap_sem) patch in sysbench.
> 
> 
> I don't want to judge the numbers since I cannot but I want to make an
> observations: even if in the SMP case MADV_FREE turns out to not be a
> bigger boost then there is still the UP case to keep in mind where Rik
> measured a significant speed-up.  As long as the SMP case isn't hurt
> this is reaosn enough to use the patch.  With more and more cores on one
> processor SMP systems are pushed evermore to the high-end side.  You'll
> find many installations which today use SMP will be happy enough with
> many-core UP machines.

OK, sure. I think we need more numbers though.

And even if this was a patch with _no_ possibility for regressions and it
was a completely trivial one that improves performance in some cases...
one big problem is that it uses another page flag.

I literally have about 4 or 5 new page flags I'd like to add today :) I
can't of course, because we have very few spare ones left.

 From the MySQL numbers on this system, it seems like performance is in the
noise, and MADV_DONTNEED makes the _vast_ majority of the improvement.
This is also the case with Rik's benchmarks, and while he did see some
improvement, I found the runs to be quite variable, so it would be ideal
to get a larger sample.

And the fact that the poor behaviour of the old style malloc/free went
unnoticed for so long indicates that it won't be the end of the world if
we didn't merge MADV_FREE right now.

-- 
SUSE Labs, Novell Inc.
