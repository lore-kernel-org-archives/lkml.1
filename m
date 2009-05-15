Return-Path: <linux-kernel-owner+w=401wt.eu-S1762915AbZEOPVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762915AbZEOPVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 11:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbZEOPVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 11:21:43 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:39213 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZEOPVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 11:21:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VSBd5sSjBerFRzLnwgCtG2RbK7k/cGuje2ZPJvhQ+ePKdDAY0Ah1L1xkqzpY7cWPwK
         cCzeyhEbPhxSJRFpB7TpRqlCH6r9WILCaf7Y4SGPmpeFScnYwN4ZoeiGhzOHJX+nWDzH
         OVBz+wnT9Q4aHLlyuu5ldJneldTrLZfXxOA8s=
MIME-Version: 1.0
In-Reply-To: <1242374931.21646.30.camel@penberg-laptop>
References: <1242289830.21646.5.camel@penberg-laptop>
	 <20090514175332.9B7B.A69D9226@jp.fujitsu.com>
	 <20090515083726.F5BF.A69D9226@jp.fujitsu.com>
	 <1242374931.21646.30.camel@penberg-laptop>
Date: Sat, 16 May 2009 00:21:42 +0900
X-Google-Sender-Auth: 5e6cc4294ab915cc
Message-ID: <2f11576a0905150821m5c602ef7g996766ae5d7f0141@mail.gmail.com>
Subject: Re: kernel BUG at mm/slqb.c:1411!
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       matthew.r.wilcox@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/15 Pekka Enberg <penberg@cs.helsinki.fi>:
> Hi Motohiro-san,
>
> On Wed, 2009-05-13 at 17:37 +0900, Minchan Kim wrote:
>> > > > On Wed, 13 May 2009 16:42:37 +0900 (JST)
>> > > > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> > > >
>> > > > Hmm. I don't know slqb well.
>> > > > So, It's just my guess.
>> > > >
>> > > > We surely increase l->nr_partial in  __slab_alloc_page.
>> > > > In between l->nr_partial++ and call __cache_list_get_page, Who is decrease l->nr_partial again.
>> > > > After all, __cache_list_get_page return NULL and hit the VM_BUG_ON.
>> > > >
>> > > > Comment said :
>> > > >
>> > > >         /* Protects nr_partial, nr_slabs, and partial */
>> > > >   spinlock_t    page_lock;
>> > > >
>> > > > As comment is right, We have to hold the l->page_lock ?
>> > >
>> > > Makes sense. Nick? Motohiro-san, can you try this patch please?
>> >
>> > This issue is very rarely. please give me one night.
>
> On Fri, 2009-05-15 at 08:38 +0900, KOSAKI Motohiro wrote:
>> -ENOTREPRODUCED
>>
>> I guess your patch is right fix. thanks!
>
> Thank you so much for testing!
>
> Nick seems to have gone silent for the past few days so I went ahead and
> merged the patch.
>
> Did you have CONFIG_PROVE_LOCKING enabled, btw? I think I got the lock
> order correct but I don't have a NUMA machine to test it with here.

my x86_64 with CONFIG_PROVE_LOCKING don't output any warnings.

thanks.
