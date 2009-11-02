Return-Path: <linux-kernel-owner+w=401wt.eu-S932237AbZKBT4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237AbZKBT4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 14:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbZKBT4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 14:56:23 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39713 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785AbZKBT4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 14:56:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=OaBltWgDltCNCzRa1NbSH/BxzrtZ/XKMdBkrbTkoxN9Fo9DzAar6ySJm+4k+TQEYTU
         LqDwYKwKTEMzSlDRx+ffYalhhMomu1vQjJw0NF4nWO6TX0wU8YNUf7eA8vPnfZW3j9JR
         dHXVtgWEXHfrASdmW9K2tu8SHcKdCERKo7kVs=
Message-ID: <4AEF3968.6080903@gmail.com>
Date: Mon, 02 Nov 2009 20:56:24 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: David Rientjes <rientjes@google.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Memory overcommit
References: <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <4AE846E8.1070303@gmail.com> <alpine.DEB.2.00.0910281307370.23279@chino.kir.corp.google.com> <4AE9068B.7030504@gmail.com> <alpine.DEB.2.00.0910290132320.11476@chino.kir.corp.google.com> <4AE97618.6060607@gmail.com> <alpine.DEB.2.00.0910291225460.27732@chino.kir.corp.google.com> <4AEAEFDD.5060009@gmail.com> <20091030141250.GQ9640@random.random> <4AEAFB08.8050305@gmail.com> <20091030151544.GR9640@random.random>
In-Reply-To: <20091030151544.GR9640@random.random>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:

> On Fri, Oct 30, 2009 at 03:41:12PM +0100, Vedran Furač wrote:
>> Oh... so this is because apps "reserve" (Committed_AS?) more then they
>> currently need.
> 
> They don't actually reserve, they end up "reserving" if overcommit is
> set to 2 (OVERCOMMIT_NEVER)... Apps aren't reserving, more likely they
> simply avoid a flood of mmap when a single one is enough to map an
> huge MAP_PRIVATE region like shared libs that you may only execute
> partially (this is why total_vm is usually much bigger than real ram
> mapped by pagetables represented in rss). But those shared libs are
> 99% pageable and they don't need to stay in swap or ram, so
> overcommit-as greatly overstimates the actual needs even if shared lib
> loading wouldn't be 64bit optimized (i.e. large and a single one).

Thanks for info!

>> A the time of "malloc: Cannot allocate memory":
>>
>> CommitLimit:     3364440 kB
>> Committed_AS:    3240200 kB
>>
>> So probably everything is ok (and free is misleading). Overcommit is
>> unfortunately necessary if I want to be able to use all my memory.
> 
> Add more swap.

I don't use swap. With current prices of RAM, swap is history, at least
for desktops. I hate when e.g. firefox gets swapped out if I don't use
it for a while. Removing swap decreased desktop latencies drastically.
And I don't care much if I'll loose 100MB of potential free memory that
could be used for disk cache...

Regards.

Vedran

