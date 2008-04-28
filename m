Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbYD1J6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbYD1J6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762971AbYD1J6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:58:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:31812 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762963AbYD1J6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=aryr4+dsxtTe25xXQYdQ8a00UAL2ZeqSpLhfK4LvoEinVqEfvdsHWvbvm6GGEDD3I5rDHdjTM4XfQnczDa19JJBH0uymrAzDKRRHgc4tsIwEOsLXYI8uZbBuGisw4triuId4tbRr9h/HlZA3ZlQ3Q8/+HmxwsI5BZoLfwKHFx4E=
Message-ID: <48159FC2.8070909@googlemail.com>
Date: Mon, 28 Apr 2008 11:58:26 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Mika Fischer <mika.fischer@zoopnet.de>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com>	 <200801202256.48365.yinghai.lu@sun.com>	 <20080122165125.GA17992@elte.hu>	 <200801221623.20861.yinghai.lu@sun.com>	 <20080426035614.a30afb17.akpm@linux-foundation.org>	 <86802c440804272350y33d69a32o5533dc01dc5a6c96@mail.gmail.com>	 <48158CF3.60004@zoopnet.de> <86802c440804280209x401fc223w3d272c6c365e58af@mail.gmail.com> <48159C83.2090400@zoopnet.de>
In-Reply-To: <48159C83.2090400@zoopnet.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mika Fischer wrote:
> Yinghai Lu schrieb:
>>>> you should get
>>>>>  reg00: base=0x00000000 ( 0MB), size=2048MB: write-back, count=1
>>>>>  reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>>>>>  reg02: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>>>>>  reg03: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>>>>>  reg04: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>> please check
>> http://lkml.org/lkml/2008/4/28/115
> 
> OK, this time it worked!
> 
> With mtrr_chunk_size=1g:
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
> reg03: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
> reg04: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> 
> Without mtrr_chunk_size=1g:
> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
> reg01: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
> reg02: base=0xa0000000 (2560MB), size= 256MB: write-back, count=1
> reg03: base=0xb0000000 (2816MB), size= 256MB: write-back, count=1
> reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
> reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
> reg06: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> 
> Both seem equivalent and correct.
> 
> There are also no warnings anymore in the dmesg output:
> With mtrr_chunk_size=1g:
> http://bugzilla.kernel.org/attachment.cgi?id=15950
> 
> Without mtrr_chunk_size=1g:
> http://bugzilla.kernel.org/attachment.cgi?id=15951
> 
>> also, can you try 64bit too?
> 
> I'm not sure how to do this. Can I compile it under 32bit Linux? If not that
> will be difficult since I don't have space left for a 64bit installation on my
> hard-drive. Maybe Gabiel C can test 64bit?

Yes sure, done already :) I could test 32/64 bit on this box if needed.
 
> 
> Regards,
>  Mika

Gabriel
