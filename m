Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525Ab0ASIo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0ASIo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 03:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465Ab0ASIo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 03:44:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:24985 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab0ASIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 03:44:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=bTp2nwk76DnCwC+sImhPIFJdweqCs4JzzxIbeYyf91lXtW94hZLIFwUiQRCpdIWjsU
         Ef2b+cvjrwcql7Eso69lhX5X/5mATsCRKfGF+J/tjV0+ErreVNuE8MPm6icYYKycfuIs
         NveS5Lkt3oFZKs9J4aAF7LGk35DcD2ceZ7Sx8=
MIME-Version: 1.0
In-Reply-To: <20100119082638.GK14345@redhat.com>
References: <20100118141938.GI30698@redhat.com>
	 <20100118170816.GA22111@redhat.com>
	 <84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
	 <20100118181942.GD22111@redhat.com>
	 <20100118191031.0088f49a@lxorguk.ukuu.org.uk>
	 <20100119071734.GG14345@redhat.com>
	 <84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
	 <20100119075205.GI14345@redhat.com>
	 <84144f021001190007q54a334dfwed64189e6cf0b7c4@mail.gmail.com>
	 <20100119082638.GK14345@redhat.com>
Date: Tue, 19 Jan 2010 10:44:23 +0200
X-Google-Sender-Auth: f2d1d27b27a1d386
Message-ID: <84144f021001190044s397c6665qb00af48235d2d818@mail.gmail.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       minchan.kim@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On Tue, Jan 19, 2010 at 10:26 AM, Gleb Natapov <gleb@redhat.com> wrote:
>> design would still be broken, no? Did you try using (or extending)
>> posix_madvise(MADV_DONTNEED) for the guest address space? It seems to
> After mlockall() I can't even allocate guest address space. Or do you mean
> instead of mlockall()? Then how MADV_DONTNEED will help? It just drops
> page table for the address range (which is not what I need) and does not
> have any long time effect.

Oh right, MADV_DONTNEED is no good.

On Tue, Jan 19, 2010 at 10:26 AM, Gleb Natapov <gleb@redhat.com> wrote:
>> me that you're trying to use a big hammer (mlock) when a polite hint
>> for the VM would probably be sufficient for it do its job.
>>
> I what to tell to VM "swap this, don't swap that" and as far as I see
> there is no other way to do it currently.

Yeah, which is why I was suggesting that maybe posix_madvise() needs
to be extended to have a MADV_NEED_BUT_LESS_IMPORTANT flag that can be
used as a hint by mm/vmscan.c to first swap the guest address spaces.

                        Pekka
