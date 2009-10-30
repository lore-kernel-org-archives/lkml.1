Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbZJ3PNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbZJ3PNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 11:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZJ3PNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 11:13:22 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43718 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbZJ3PNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 11:13:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:organization:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:x-age:x-location
         :x-os:x-face:content-type:content-transfer-encoding;
        b=XqvwvJA7j50VAEjJ9AFnCqnQtR1uqUv4qtdk1d0GylpcKdFU27/HsEh4E6x1NKSw0a
         pKAAjeanlQhm1WhZeN6NfwXobgQ58sXOjrrlYNyQn8WcaavkUMOg4I6zGuW6IyMnMKJg
         cG+ZOYedXgGrTmwjKgApcOCAjcV+3+gMo4Qok=
Message-ID: <4AEB0291.4080003@gmail.com>
Date: Fri, 30 Oct 2009 16:13:21 +0100
From: =?UTF-8?B?VmVkcmFuIEZ1cmHEjQ==?= <vedran.furac@gmail.com>
Reply-To: vedran.furac@gmail.com
Organization: Home
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090701 Thunderbird/2.0.0.22 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: tfjellstrom@shaw.ca
CC: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
References: <hav57c$rso$1@ger.gmane.org> <alpine.DEB.2.00.0910291225460.27732@chino.kir.corp.google.com> <4AEAEFDD.5060009@gmail.com> <200910300808.38450.tfjellstrom@shaw.ca>
In-Reply-To: <200910300808.38450.tfjellstrom@shaw.ca>
X-Age: 25
X-Location: Lovran, Croatia
X-OS: Debian GNU/Linux
X-Face: +Lg7^E:?#]P.Y{N@61yW{aY#>fRcOE6MMqgAM|Kwk"fK!y!i4+h6&?E`Jt@uame[-SLu#*<fGtMmVfh8qo,"kJ'ql^Ni?]l|ax{fvvmD<k:2w^e(y8J2YWO`M=u17OWli}Rf^e:|w2]LulgE(:u0|}mNBZFid[YEWAC>?k:)dZv<!'a)N0b=LFDZKY!!@[%mmVO-7y`Nkj?{<C6rm9Uz$EXu;0I<PubM.Po|vlT.2&vPkJG07G.l0Ty)B/dR0k:KU<;?+WAR\f_ms2b~i"g@e}a)i1N$WLBa{vBoDs4!}k\g?lItt=|]=M{Fm@ce|^6PXq&
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Fjellstrom wrote:

>> malloc: Cannot allocate memory /* Great, no OOM, but: */
>> 
>> % free -m total       used       free     shared    buffers cached
>> Mem:      3458        3429         29          0        102 1119
>> -/+ buffers/cache:    2207       1251
>> 
>> There's plenty of memory available. Shouldn't cache be 
>> automatically dropped (this question was in my original mail, hence
>>  the subject)?
>> 
> 
> I think this is the MOST serious issue related to the oom killer. For
> some reason it refuses to drop pages before trying to kill. When it
> should drop cache, THEN kill if needed.

This isn't about OOM, but situation when you turn off overcommit. I was
jumping to conclusion here. You can drop caches manually with:
# echo 1 > /proc/sys/vm/drop_caches

but you still get: "malloc: Cannot allocate memory" even if almost
nothing is cached:

        total       used       free     shared    buffers     cached
Mem:    3458       2210       1248          0          3          90
-/+ buffers/cache: 2116       1342

As for not dropping pages by kernel before killing, I don't know nothing
about it. It happens so fast and I never tried to measure it.
