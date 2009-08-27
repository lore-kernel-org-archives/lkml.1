Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbZH0T2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbZH0T2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 15:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZH0T2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 15:28:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbZH0T2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 15:28:38 -0400
Message-ID: <4A96DFFF.1040501@redhat.com>
Date: Thu, 27 Aug 2009 22:35:27 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/12] ksm: fix munlock during exit_mmap deadlock
References: <20090825145832.GP14722@random.random> <20090825152217.GQ14722@random.random> <Pine.LNX.4.64.0908251836050.30372@sister.anvils> <20090825181019.GT14722@random.random> <Pine.LNX.4.64.0908251958170.5871@sister.anvils> <20090825194530.GU14722@random.random> <Pine.LNX.4.64.0908261910530.15622@sister.anvils> <20090826194444.GB14722@random.random> <Pine.LNX.4.64.0908262048270.21188@sister.anvils> <4A95A10C.5040008@redhat.com> <20090826211400.GE14722@random.random> <4A95AE06.305@redhat.com> <Pine.LNX.4.64.0908271958330.1973@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0908271958330.1973@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
>
> It may be that MADV_UNMERGEABLE isn't really needed (I think I even
> admitted once that probably nobody would use it other than we testing
> it).  Yet I hesitate to rip it out: somehow it still seems right to
> have it in there.  Why did you have unregistering in the /dev/ksm KSM?
>   

It was more to give possiblaty to applications save cpu cycles of ksmd 
so it wont continue to scan memory regions that don`t need ksm anymore,
As you said if someone will ever use it?, have no idea...

>   
> I didn't seem idiotic to me, but I hadn't realized the ksmd timelapse
> uncertainty Andrea points out.  Well, I'm not keen to change the way
> it's working at present, but I do think you're right to question all
> these aspects of unmerging.
>   

Yes lets keep it like that, UNMERGEABLE sound anyway like something that 
going to break the pages..., we can always add later STOPMERGE as a call 
that tell ksm to stop merge the pages but not break the shared pages...

> Hugh
>   

