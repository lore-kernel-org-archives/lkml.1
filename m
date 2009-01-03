Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbZACTNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbZACTNj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 14:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbZACTNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 14:13:30 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:33622 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757301AbZACTN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 14:13:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FU2p/UGe4ObEq+1q6ChLE7PzU/Qd7rELI/vU2fTfDWqaB4q8GfEWyJWDwibFBrqv8Q
         iCJuSnVgHTTH+mACfMv9ExBFh9+1ReHlkqaH6mj8Spb+bA8GxKcEnJU5dG0Fl0R3bgRL
         Bmtt9rKYbL00FeKESyRQhSWb83srow0B+NjSk=
Date: Sat, 3 Jan 2009 22:03:16 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: david@lang.hm
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
Message-ID: <20090103190316.GB7367@localhost>
References: <alpine.DEB.1.10.0901021029010.21408@asgard.lang.hm> <20090102173441.GC5372@localhost> <alpine.DEB.1.10.0901021044460.21408@asgard.lang.hm> <20090102174845.GD5372@localhost> <20090102175226.GE5372@localhost> <alpine.DEB.1.10.0901021131210.21567@asgard.lang.hm> <20090102203058.GH5372@localhost> <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm> <20090103161052.GB11093@localhost> <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(list restored)

[david@lang.hm - Sat, Jan 03, 2009 at 11:19:00AM -0800]
...
>>>
>>> two new screenshots at http://linux.lang.hm/linux
>>>
>>> 36 is a boot with just earlyprintk=vga
>>> 37 is a boot with numa=noacpi
>>> I also put the vmlinux file there, I'll put the System.map and config
>>> there later (I did enable kernel_debug on this build as well)
>>>
>>> David Lang
>>>
>>
>> David, I can't find vmlinux neither .config?
>> Maybe they have hidden attribute?
>
> oops, they are there now.
>
> David Lang
>

ok, according to failing address we've a BUG_ON
triggered

---
(gdb) l *0xffffffff8096452a
0xffffffff8096452a is in alloc_bootmem_core (mm/bootmem.c:442).
437		unsigned long fallback = 0;
438		unsigned long min, max, start, sidx, midx, step;
439	
440		BUG_ON(!size);
441		BUG_ON(align & (align - 1));
442		BUG_ON(limit && goal + size > limit);
443	
444		if (!bdata->node_bootmem_map)
445			return NULL;
446	
(gdb) 
---

so we're in attempt to overrun 'limit'.
Hmm...

		- Cyrill -
