Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbZEFSCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbZEFSCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZEFSCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:02:32 -0400
Received: from waste.org ([66.93.16.53]:56459 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbZEFSCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:02:31 -0400
Date: Wed, 6 May 2009 12:57:17 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090506175717.GY31071@waste.org>
References: <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 09:48:20AM -0700, Linus Torvalds wrote:
> 
> Matt, are you willing to ack my suggested patch which adds history to the 
> mix? Did somebody test that? I have this memory of there being an 
> "exploit" program to show the non-randomness of the values, but I can't 
> recall details, and would really want to get a second opinion from 
> somebody who cares about PRNG's.

I still don't like it. I bounced it off some folks on the adversarial
side of things and they didn't think it looked strong enough either.
Full MD5 collisions can be generated about as fast as they can be
checked, which makes _reduced strength_ MD4 not much better than an
LFSR in terms of attack potential. So I suggest we either:

a) take my original patch 
b) respin your patch using at least SHA1 rather than halfMD4 and
changing the name to get_random_u32

If you'd prefer (b), I'll do the legwork.

-- 
Mathematics is the supreme nostalgia of our time.
