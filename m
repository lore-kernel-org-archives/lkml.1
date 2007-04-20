Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbXDTVY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbXDTVY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbXDTVY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:24:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:12922 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbXDTVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Cfs7/VIDmNzNUDLkXJFE5Oq74K+5rUfr3/vKoX0kTdjtJiHG03dzyf8v6DQbf4SCDSCmPJDF7gCt5Et5LmAKo53QXVMxdMOKgK2NJ5qd7xx3jbWXv7+oX753j3YyW5Crrfq0TB49fTtSSAxopkQpZdYSriIIWD+mE6DnXTv3iR4=
Message-ID: <a36005b50704201424q3c07d457m6b2c468ff8a826c7@mail.gmail.com>
Date: Fri, 20 Apr 2007 14:24:55 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE 2/2
Cc: "Rik van Riel" <riel@redhat.com>, "Jakub Jelinek" <jakub@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20070420140316.e0155e7d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46247427.6000902@redhat.com> <4627DBF0.1080303@redhat.com>
	 <20070420140316.e0155e7d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> OK, we need to flesh this out a lot please.  People often get confused
> about what our MADV_DONTNEED behaviour is.

Well, there's not really much to flesh out.  The current MADV_DONTNEED
is useful in some situations.  The behavior cannot be changed, even
glibc will rely on it for the case when MADV_FREE is not supported.

What might be nice to have is to have a POSIX-compliant
POSIX_MADV_DONTNEED implementation.  We currently do nothing which is
OK since no test suite can detect that.  But some code might want to
use the real behavior and we're missing an optimization possibility.

Just for reference: the MADV_CURRENT behavior is to throw away data in
the range.  The POSIX_MADV_DONTNEED behavior is to never lose data.
I.e., file backed data is written back, anon data is at most swapped
out.
