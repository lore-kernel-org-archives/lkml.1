Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbZI2MQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbZI2MQd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbZI2MQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:16:32 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:49367 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbZI2MQc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VvSMPE9+hJdIgqEb6LQJSF6VE8pVVUXXVCqVWACgxauzVUmai5K/4QSqRq/M4KsGdY
         hIitxNIltadJwj0/HqirBj/rRqaiHNa8QjcTKFaM3NAJU+rn6GrnM43xngjILGHyInQq
         jjJw/sCHrXz55FcBGNGnNpBDJmctruDBQK4FI=
MIME-Version: 1.0
In-Reply-To: <20090929135925.50ac88bf@infradead.org>
References: <f22d86810909290425s46406fe5ib00bcfc9673f70df@mail.gmail.com>
	 <20090929135925.50ac88bf@infradead.org>
Date: Tue, 29 Sep 2009 17:46:35 +0530
Message-ID: <f22d86810909290516l4cdda2bav3588cc5f7d1f2f65@mail.gmail.com>
Subject: Re: GFP_NOWAIT and GFP_NOMEMALLOC
From: "Leonidas ." <leonidas137@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 5:29 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 29 Sep 2009 16:55:24 +0530
> "Leonidas ." <leonidas137@gmail.com> wrote:
>
>> Hi list,
>>
>> I am new here, I have googled/binged enough before posting this
>> message, in case of redundancy please point me to appropriate
>> links/resources etc.
>>
>> I want to kmalloc memory while holding spinlocks in process context,
>> here I can't use GFP_KERNEL flag since it can sleep. Using GFP_ATOMIC
>> guarantees that allocation will succeed by allocating from emergency
>> pools if needed. But I dont think, I need to use emergency pool and I
>> want to limit my memory consumption to ZONE_NORMAL without sleeping,
>> my module is ready to handle the allocation failure if any.
>
> GFP_NOWAIT is what you want.
>
> can you give us a pointer to what your module is about? Maybe there's
> better solutions...
>
>
> --
> Arjan van de Ven        Intel Open Source Technology Centre
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>


The module is going to be a profiling module and the user module which
is under profiling
will call the apis which I am exporting. My apis will collect certain
data from point
it is called and populate internal data strcuctures. My apis can be
called from process
context as well as interrupt context hence I am using spinlocks as
locking mechanism.
The amount of memory I am allocating each time my api is called around
100 bytes,
and in worst case I might end up allocating tens of thousands of
objects of almost same
size. I am aware that in such a scenario I should be using some kind
of memory pool
mechanism and preallocate my buffers to avoid frequent
allocations/deallocations.

But frankly, I am not very familiar with Linux kernel apis yet hence
have resorted to
using a tree data structure for the first cut where I allocate memory as needed
depending on the context I am executing in. To optimize a bit, I do
not free my memory
till some threshold is reached.

Some questions here:

1. GFP_NOWAIT as in kmalloc(size, GFP_KERNEL | GFPNOWAIT)?

or

kmalloc(size, GFP_NOWAIT), I know this one is a dumb one.

2. Any reference for the mempool kind of implementation mentioned above?

3. Any other pointers about design, references etc would be helpful.

-Leo.
