Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbZFLItj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbZFLItj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbZFLItc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:49:32 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:47903 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239AbZFLIta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:49:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=eiL07dKxaqCiiCePi7Rd9mtgnUZKKqPfEwL6Dxoa3RTJKk/+Jg4lhH/sDAdmYtDHHR
         6TuRTs5dj9q8GtYXmjjC1Epf2PIu0EHqoJ122AULpCFf+sz8iidn83ldvY5DWsszUGTb
         WO7rQcP4tRgWQWTbHcX9AYRMr8vKiqGPIixZo=
MIME-Version: 1.0
In-Reply-To: <1244796291.7172.87.camel@pasglop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>
	 <1244792745.30512.13.camel@penberg-laptop>
	 <20090612075427.GA24044@wotan.suse.de>
	 <1244793592.30512.17.camel@penberg-laptop>
	 <20090612080236.GB24044@wotan.suse.de>
	 <1244793879.30512.19.camel@penberg-laptop>
	 <1244796291.7172.87.camel@pasglop>
Date: Fri, 12 Jun 2009 11:49:31 +0300
X-Google-Sender-Auth: 596d85a05699f041
Message-ID: <84144f020906120149k6cbe5177vef1944d9d216e8b2@mail.gmail.com>
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 11:44 AM, Benjamin
Herrenschmidt<benh@kernel.crashing.org> wrote:
> On Fri, 2009-06-12 at 11:04 +0300, Pekka Enberg wrote:
>> Hi Nick,
>>
>> On Fri, 2009-06-12 at 10:02 +0200, Nick Piggin wrote:
>> > Fair enough, but this can be done right down in the synchronous
>> > reclaim path in the page allocator. This will catch more cases
>> > of code using the page allocator directly, and should be not
>> > as hot as the slab allocator.
>>
>> So you want to push the local_irq_enable() to the page allocator too? We
>> can certainly do that but I think we ought to wait for Andrew to merge
>> Mel's patches to mainline first, OK?
>
> Doesn't my patch take care of all the cases in a much more simple way ?

Nick, the patch Ben is talking about is here:

http://patchwork.kernel.org/patch/29700/

The biggest problem with the patch is that the gfp_smellybits is wide
open for abuse. Hmm.

                        Pekka
