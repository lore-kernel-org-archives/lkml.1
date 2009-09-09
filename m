Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZIIPjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZIIPjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZIIPi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:38:59 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:51498 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZIIPi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:38:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SB/O4JjK7+J7R0R2SPahebJac4HcJW0YvfXyIM/wo23h4uDgMzXVItRGTBtajh9CKB
         RqVk18N4oMvFwzrXNbrqP38lxz/X91fBkJ6p7k49JlPtx/k9M/RxzaAyKJJMu6fbEUvK
         nBce3RqlYSnpSNff7MgXBj5fYD2Msw6ky6T0g=
MIME-Version: 1.0
In-Reply-To: <20090909131945.0CF5.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.1.10.0909081110450.30203@V090114053VZO-1>
	 <alpine.DEB.1.10.0909081124240.30203@V090114053VZO-1>
	 <20090909131945.0CF5.A69D9226@jp.fujitsu.com>
Date: Thu, 10 Sep 2009 00:39:02 +0900
Message-ID: <28c262360909090839j626ff818of930cf13a6185123@mail.gmail.com>
Subject: Re: [rfc] lru_add_drain_all() vs isolation
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <onestero@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 1:27 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> The usefulness of a scheme like this requires:
>>
>> 1. There are cpus that continually execute user space code
>>    without system interaction.
>>
>> 2. There are repeated VM activities that require page isolation /
>>    migration.
>>
>> The first page isolation activity will then clear the lru caches of the
>> processes doing number crunching in user space (and therefore the first
>> isolation will still interrupt). The second and following isolation will
>> then no longer interrupt the processes.
>>
>> 2. is rare. So the question is if the additional code in the LRU handling
>> can be justified. If lru handling is not time sensitive then yes.
>
> Christoph, I'd like to discuss a bit related (and almost unrelated) thing.
> I think page migration don't need lru_add_drain_all() as synchronous, because
> page migration have 10 times retry.
>
> Then asynchronous lru_add_drain_all() cause
>
>  - if system isn't under heavy pressure, retry succussfull.
>  - if system is under heavy pressure or RT-thread work busy busy loop, retry failure.
>
> I don't think this is problematic bahavior. Also, mlock can use asynchrounous lru drain.

I think, more exactly, we don't have to drain lru pages for mlocking.
Mlocked pages will go into unevictable lru due to
try_to_unmap when shrink of lru happens.
How about removing draining in case of mlock?

>
> What do you think?
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
