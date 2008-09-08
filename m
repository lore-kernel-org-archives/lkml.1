Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYIHPB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYIHPB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 11:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYIHPBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 11:01:48 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34181 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750989AbYIHPBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 11:01:48 -0400
Message-ID: <48C53E59.9010709@sgi.com>
Date: Mon, 08 Sep 2008 08:01:45 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bert Wesarg <bert.wesarg@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, davej@codemonkey.org.uk,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 11/13] genapic: reduce stack pressuge in io_apic.c step
 3	target_cpus
References: <20080906235036.891970000@polaris-admin.engr.sgi.com> <20080906235038.421559000@polaris-admin.engr.sgi.com> <36ca99e90809070055u3b3b8415i2a5dbfb6bf617d35@mail.gmail.com> <20080907091332.GC5574@elte.hu>
In-Reply-To: <20080907091332.GC5574@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>> +#ifdef CONFIG_X86_64
>>> +#define TARGET_CPUS(retval)      (genapic->target_cpus)(&(retval))
>>> +#else
>>> +#define TARGET_CPUS(retval)      retval = (genapic->target_cpus())
>>> +#endif
> 
> hm, this should be unified.
> 
> 	Ingo

As I did that one first, I didn't want to muddle through too much i386 code,
but when I did the vector_allocation_domain, it became more clear that making
them common would be better.

I also tripped myself up because one of my test i386 configs had 64 cpus and
it fired up the "NR_CPUS > BITS_PER_LON" code. ;-)  [And I'm supposing it's
probably justified to believe that there may be "fairly large" 32-bit systems,
for those applications that need horsepower but not a lot of memory.]

Thanks,
Mike
