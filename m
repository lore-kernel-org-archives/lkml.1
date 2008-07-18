Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYGRJCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYGRJCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYGRJC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:02:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:35272 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbYGRJC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pUYmLi9IUIyqoiO3edndgXo0JcrIvLiHgTROJnuoFZSjD4DTu61EVG3kO/+0i+wPfO
         +S94yK7Fy2sX/y1uMi5TADbfeoUo3c15NKwQzzRCa/PKaPLB+TX8EprIyXrRVDLrgJmQ
         4nUaZ0H9c/G1cAmDTjMwdOu10x3hsW7ot2XMc=
Message-ID: <84144f020807180202l6c703234ic3a2b57e73a1d89a@mail.gmail.com>
Date: Fri, 18 Jul 2008 12:02:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080718054626.GA3338@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
	 <20080718054626.GA3338@2ka.mipt.ru>
X-Google-Sender-Auth: 39c287d2afecb3a0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Evgeniy,

On Fri, Jul 18, 2008 at 8:46 AM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Hi Ingo.
>
> On Thu, Jul 17, 2008 at 11:42:22PM +0200, Ingo Molnar (mingo@elte.hu) wrote:
>> Pid: 5098, comm: gdm-binary Not tainted 2.6.26-tip #3094
>>  [<c0186f99>] print_trailer+0xa9/0xf0
>>  [<c018707b>] check_bytes_and_report+0x9b/0xc0
>>  [<c01874ae>] check_object+0x19e/0x1e0
>>  [<c0187ef1>] __slab_alloc+0x371/0x4e0
>>  [<c0188552>] kmem_cache_alloc+0xb2/0xc0
>>  [<c06732dc>] ? __alloc_skb+0x2c/0x110
>
> Out of curiosity, why does it scream at allocation time?

Because it's checking for use-after-free errors. The object is
poisoned with POISON_FREE when it's free'd and we verify the poison
values at allocation time.

On Fri, Jul 18, 2008 at 8:46 AM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Does SLUB have a debug check at freeing time? If so, how does it work
> and why didn't it caught use after free there?

You can't detect use after free before the object is actually free'd ;-)

                                      Pekka
