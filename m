Return-Path: <linux-kernel-owner+w=401wt.eu-S932767AbZACXxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767AbZACXxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZACXx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:53:29 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:29927 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZACXx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:53:28 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=lQM9uPPJo2TM3DhRSf4A:9 a=p1a-eE4MM1A35dTRLZEi_470rUkA:4 a=_PE_9BDqzpwA:10 a=NF7nOHhYDaEA:10
Message-ID: <495FFA73.6030705@shaw.ca>
Date: Sat, 03 Jan 2009 17:53:23 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.documentation,gmane.linux.kernel
To: Pavel Machek <pavel@suse.cz>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
   from unsigned long
References: <20090103124400.GA1572@ucw.cz> <20090103201955.186974bb@lxorguk.ukuu.org.uk> <20090103202740.GC1666@elf.ucw.cz> <20090103203044.0166b561@lxorguk.ukuu.org.uk> <20090103205628.GE1666@elf.ucw.cz>
In-Reply-To: <20090103205628.GE1666@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sat 2009-01-03 20:30:44, Alan Cox wrote:
>>> If it is okay and linux relies on it, it should be documented.
>>>
>>> If it is not okay, I guess we should document it, too -- it seems to
>>> be common mistake. 
>> A lot of old code did it knowing it was under the BKL, outside of the BKL
>> its a very bad idea. There were lots of them in the tty layer and I don't
>> doubt there are some left I missed too 8(
> 
> I have seen this in new code (some LED driver last time), definitely
> no BKL.
> 
> Is there concrete architecture where it breaks? I'd expect i386/x86-64
> to be safe, and pretty much everyone to be safe as long as that long
> is aligned.... or that was the result of arch-maintainers
> discussion...
> 
> I'd really like to document if it is right or not, so that I can point
> people to documentation...
> 								Pavel

If you look at the atomic implementation on x86 all it does is assign 
and read the internal int variable directly for atomic_set and 
atomic_read, so I suppose it would be OK to just use a normal variable 
in that case.. but then there's no performance hit so you might as well 
use atomic_t anyway. On some architectures like arm and sparc there is 
some magic involved in atomic_set and/or atomic_read (but those may just 
be to guard against other concurrent atomic ops, I'm not sure).

Certainly unless the code is really performance critical there is no 
point messing around, just use an atomic if it needs to be accessed 
without locking. Note that memory barriers may be an issue as well..
