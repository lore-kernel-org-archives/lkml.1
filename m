Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYGaUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYGaUCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 16:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYGaUCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 16:02:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:57328 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbYGaUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 16:02:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=epW8DEmoVhE7k/8rZuL1r8i8Mpupr84mcyVjvasrlLonor2shZzcfjEiWV18ODegh
	5hAteTauH3BH4XNViBlZQ==
Message-ID: <6599ad830807311302p2b5dbd46h849d8ffcec65fc48@mail.gmail.com>
Date: Thu, 31 Jul 2008 13:02:39 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cpuset: make ntasks to be a monotonic increasing value
Cc: laijs@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080731143827.b8bf7bce.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48912FDD.8060006@cn.fujitsu.com>
	 <20080731072355.b582b2d6.pj@sgi.com> <4891B9E0.2090900@cn.fujitsu.com>
	 <20080731083706.e6bd4acc.pj@sgi.com>
	 <6599ad830807311006r24e4d325ie505949ad760afd@mail.gmail.com>
	 <20080731143827.b8bf7bce.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 12:38 PM, Paul Jackson <pj@sgi.com> wrote:
> Paul M wrote:
>> That loop really could do with some updates though - currently it
>> looks at the mm for every task in the cpuset, rather than filtering
>> duplicate mms from threaded applications.
>
> Interesting.
>
> After a quick glance, I suppose that we'd still have:
>  1) allocate an mmarray[] in that particular loop as we do now,
>    sized large enough for all tasks,
>  2) convert each task to it's mm, in the next code chunk, with:
>        mm = get_task_mm(p);
>
> but that then, before we call "mpol_rebind_mm()" for each such
> mm, we could essentially do a "sort -u" (sort unique) on that
> mmarray[], to remove duplicate mm's.  This would not change any
> of the existing loops; rather just add one more code paragraph,
> to remove the duplicate mm's.

Yes, something like that.

Paul
