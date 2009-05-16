Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbZEPPts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbZEPPts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 11:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbZEPPtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 11:49:39 -0400
Received: from 1wt.eu ([62.212.114.60]:1427 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbZEPPti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 11:49:38 -0400
Date: Sat, 16 May 2009 17:47:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, security@kernel.org, Linux@hera.kernel.org,
       stable@kernel.org, Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan@hera.kernel.org, List <linux-kernel@vger.kernel.org>,
       Alan@hera.kernel.org, Eric Paris <eparis@redhat.com>,
       Jake Edge <jake@lwn.net>, linux-security-module@vger.kernel.org,
       mingo@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Matt Mackall <mpm@selenic.com>, Dave Jones <davej@redhat.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
Message-ID: <20090516154705.GA27139@1wt.eu>
References: <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090514164737.6eaab4f0@chukar> <alpine.LFD.2.01.0905141553010.3343@localhost.localdomain> <20090515134717.GA16389@elte.hu> <20090516100039.GA24619@1wt.eu> <20090516103909.GB6261@elte.hu> <20090516135828.GA25283@1wt.eu> <alpine.LFD.2.01.0905160811550.3301@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905160811550.3301@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 08:23:11AM -0700, Linus Torvalds wrote:
> But at the same time, I personally suspect that it would be _much_ easier 
> to attack the hash if we actually gave out the whole 16 bytes (over 
> several iteration), when compared to what we do now (only give out a small 
> part and then re-hash). I can't back that up with any proofs, though, but 
> I suspect it's much harder to re-generate the hash if you never see more 
> than a very small part of the output.

if we use incremental values (such as modulus after a multiply), yes. But
SHA1 is not know yet to be easily reversible. I mean, it's not because you
can read the 160 bits of a hash which corresponds to a stupid counter that
you can guess the next 160 bits you will get. Of course the "stupid counter"
I'm speaking about must include some randomness itself so that it does not
end up with a small set of finite elements. But I'm not worried at all about
giving out all of the 160 bits of an SHA1 result.

Willy

