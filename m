Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbYD1Jor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbYD1Jor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYD1Joj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:44:39 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:51150 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYD1Joi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:44:38 -0400
Message-ID: <48159C83.2090400@zoopnet.de>
Date: Mon, 28 Apr 2008 11:44:35 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>, balajirrao@gmail.com
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com>	 <200801202256.48365.yinghai.lu@sun.com>	 <20080122165125.GA17992@elte.hu>	 <200801221623.20861.yinghai.lu@sun.com>	 <20080426035614.a30afb17.akpm@linux-foundation.org>	 <86802c440804272350y33d69a32o5533dc01dc5a6c96@mail.gmail.com>	 <48158CF3.60004@zoopnet.de> <86802c440804280209x401fc223w3d272c6c365e58af@mail.gmail.com>
In-Reply-To: <86802c440804280209x401fc223w3d272c6c365e58af@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu schrieb:
>>> you should get
>>>>  reg00: base=0x00000000 ( 0MB), size=2048MB: write-back, count=1
>>>>  reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
>>>>  reg02: base=0xbf700000 (3063MB), size= 1MB: uncachable, count=1
>>>>  reg03: base=0xbf800000 (3064MB), size= 8MB: uncachable, count=1
>>>>  reg04: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> please check
> http://lkml.org/lkml/2008/4/28/115

OK, this time it worked!

With mtrr_chunk_size=1g:
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
reg03: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
reg04: base=0x100000000 (4096MB), size=1024MB: write-back, count=1

Without mtrr_chunk_size=1g:
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size= 512MB: write-back, count=1
reg02: base=0xa0000000 (2560MB), size= 256MB: write-back, count=1
reg03: base=0xb0000000 (2816MB), size= 256MB: write-back, count=1
reg04: base=0xbf700000 (3063MB), size=   1MB: uncachable, count=1
reg05: base=0xbf800000 (3064MB), size=   8MB: uncachable, count=1
reg06: base=0x100000000 (4096MB), size=1024MB: write-back, count=1

Both seem equivalent and correct.

There are also no warnings anymore in the dmesg output:
With mtrr_chunk_size=1g:
http://bugzilla.kernel.org/attachment.cgi?id=15950

Without mtrr_chunk_size=1g:
http://bugzilla.kernel.org/attachment.cgi?id=15951

> also, can you try 64bit too?

I'm not sure how to do this. Can I compile it under 32bit Linux? If not that
will be difficult since I don't have space left for a 64bit installation on my
hard-drive. Maybe Gabiel C can test 64bit?

Regards,
 Mika
