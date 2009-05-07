Return-Path: <linux-kernel-owner+w=401wt.eu-S1762710AbZEGSFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762710AbZEGSFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbZEGSFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:05:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55713 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445AbZEGSFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:05:19 -0400
Date: Thu, 7 May 2009 10:53:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matt Mackall <mpm@selenic.com>
cc: Florian Weimer <fweimer@bfk.de>, security@kernel.org,
       Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dave Jones <davej@redhat.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged
 processes
In-Reply-To: <20090507165545.GK31071@waste.org>
Message-ID: <alpine.LFD.2.01.0905071040130.4983@localhost.localdomain>
References: <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org>
 <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506175717.GY31071@waste.org> <82prel54fo.fsf@mid.bfk.de> <20090507165545.GK31071@waste.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 May 2009, Matt Mackall wrote:
> 
> We have a better hash function handy, and it's only takes twice as long.

Matt, I really don't like your notion of "only twice as long".

I mean, really. In the kernel, we tend to never even talk about how many 
_times_ slower something is. We talk about cycles or small percentages.

The fact is, the current "get_random_int()" is a joke, and will return the 
same value over and over again for long stretches of time. I mean, really. 
Even people who don't care a lot would expect more than _that_ out of a 
PRNG.

And quite frankly, a lot of the users of get_random_int() probably use it 
not as some crypto function, but as a replacement for not having to write 
their own copy of some standard PRNG linear congruential generator.

I mean, really. The virtual address randomization was never meant to be 
"cryptographically secure" in that sense. Dammit, look at the code: it 
only takes something like 8 bits of the results _anyway_.

In other words, YOUR WHOLE ARGUMENT IS TOTALLY INSANE. You talk about 
"cryptographically secure hashes" for some 8-bit value. Listen to 
yourself. At that point, any cryptographer will just ridicule you. There's 
no point in trying to break the randomness, because you'll be much better 
off just trying a lot of different values.

So Matt, get with the program already. Don't ignore the performance 
argument by saying "it's only twice as slow". Admit it - that's just 
idiotic.

If somebody _really_ wants true randomness, teach them to use 
"get_random_bytes()" by all means. 

			Linus
