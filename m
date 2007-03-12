Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXCLI3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXCLI3L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 04:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965349AbXCLI3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 04:29:11 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:34393 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965356AbXCLI3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 04:29:09 -0400
Message-ID: <45F50FCC.1020309@sw.ru>
Date: Mon, 12 Mar 2007 11:31:08 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Herbert Poetzl <herbert@13thfloor.at>
CC: Andrew Morton <akpm@linux-foundation.org>, Kirill Korotaev <dev@sw.ru>,
       containers@lists.osdl.org, Paul Menage <menage@google.com>,
       List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/7] RSS controller core
References: <45ED7DEC.7010403@sw.ru> <45ED80E1.7030406@sw.ru> <20070306140036.4e85bd2f.akpm@linux-foundation.org> <20070309164855.GB3647@MAIL.13thfloor.at> <45F3C700.3060106@sw.ru> <20070311143254.GC3696@MAIL.13thfloor.at> <45F41A7C.3000900@sw.ru> <20070312004152.GB21861@MAIL.13thfloor.at>
In-Reply-To: <20070312004152.GB21861@MAIL.13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[snip]

>>>>>> We need to decide whether we want to do per-container memory
>>>>>> limitation via these data structures, or whether we do it via
>>>>>> a physical scan of some software zone, possibly based on Mel's
>>>>>> patches.
>>>>> why not do simple page accounting (as done currently
>>>>> in Linux) and use that for the limits, without
>>>>> keeping the reference from container to page?
>>>> As I've already answered in my previous letter simple
>>>> limiting w/o per-container reclamation and per-container
>>>> oom killer isn't a good memory management. It doesn't allow
>>>> to handle resource shortage gracefully.
>>> per container OOM killer does not require any container
>>> page reference, you know _what_ tasks belong to the 
>>> container, and you know their _badness_ from the normal
>>> OOM calculations, so doing them for a container is really
>>> straight forward without having any page 'tagging'
>> That's true. If you look at the patches you'll
>> find out that no code in oom killer uses page 'tag'.
> 
> so what do we keep the context -> page reference
> then at all?

We need this for
1. keeping page's owner to uncharge to IT when page
   goes away. Or do you propose to uncharge it to
   current (i.e. ANY) container like you do all across
   Vserver accounting which screws up accounting with
   pages sharing?
2. managing LRU lists for good reclamation. See Balbir's
   patches for details.
3. possible future uses - correct sharing accounting,
   dirty pages accounting, etc

>>> for the reclamation part, please elaborate how that will
>>> differ in a (shared memory) guest from what the kernel
>>> currently does ...
>> This is all described in the code and in the
>> discussions we had before.
> 
> must have missed some of them, please can you
> point me to the relevant threads ...

lkml.org archives and google will help you :)

> TIA,
> Herbert
