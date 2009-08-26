Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZHZWAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZHZWAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 18:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZHZWAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 18:00:21 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48289 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbZHZWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 18:00:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=d4gcUmCBNc9B9cm5iAVh5NTZYF1zYsGttfTHpmfEo9YouTKk0AmLMyhbSEbq8QX0n
	UMDNh/kUUVCYHpLKwdElg==
Date: Wed, 26 Aug 2009 15:00:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Izik Eidus <ieidus@redhat.com>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>, Chris Wright <chrisw@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Justin M. Forbes" <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 13/12] ksm: fix munlock during exit_mmap deadlock
In-Reply-To: <20090826211400.GE14722@random.random>
Message-ID: <alpine.DEB.2.00.0908261457140.12052@chino.kir.corp.google.com>
References: <20090825145832.GP14722@random.random> <20090825152217.GQ14722@random.random> <Pine.LNX.4.64.0908251836050.30372@sister.anvils> <20090825181019.GT14722@random.random> <Pine.LNX.4.64.0908251958170.5871@sister.anvils> <20090825194530.GU14722@random.random>
 <Pine.LNX.4.64.0908261910530.15622@sister.anvils> <20090826194444.GB14722@random.random> <Pine.LNX.4.64.0908262048270.21188@sister.anvils> <4A95A10C.5040008@redhat.com> <20090826211400.GE14722@random.random>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Andrea Arcangeli wrote:

> In oom deadlock terms madvise(UNMERGEABLE) is the only place that is
> 100% fine at breaking KSM pages, because it runs with right tsk->mm
> and page allocation will notice TIF_MEMDIE set on tsk.
> 

Be aware that the page allocator in Linus' git will not notice TIF_MEMDIE 
for current if that task is chosen for oom kill since alloc_flags are not 
updated for that particular allocation.  My patch in -mm,
mm-update-alloc_flags-after-oom-killer-has-been-called.patch, fixes that 
but is not yet merged (I assume it's on hold for 2.6.32?).

I'd hate for you to run into this in testing and spend time debugging it 
when the problem already has a fix.
