Return-Path: <linux-kernel-owner+w=401wt.eu-S1761398AbXGZMAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761398AbXGZMAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXGZL7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 07:59:52 -0400
Received: from ns.suse.de ([195.135.220.2]:46694 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbXGZL7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 07:59:52 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: i386-show-unhandled-signals-v3
Date: Thu, 26 Jul 2007 13:59:46 +0200
User-Agent: KMail/1.9.6
Cc: "Masoud Sharbiani" <masouds@google.com>,
       "Kirill Korotaev" <dev@openvz.org>, linux-kernel@vger.kernel.org
References: <20070718154759.GA26425@google.com> <200707261146.23886.ak@suse.de> <20070726031406.3866ddc5.akpm@linux-foundation.org>
In-Reply-To: <20070726031406.3866ddc5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707261359.46936.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2007 12:14:06 Andrew Morton wrote:
> On Thu, 26 Jul 2007 11:46:23 +0200 Andi Kleen <ak@suse.de> wrote:
> 
> > 
> > > Look: if there's a way in which an unprivileged user can trigger a printk
> > > we fix it, end of story. 
> > 
> > I'm firmly against disabling it on x86-64 by default.
> 
> We know you are, and the consensus and past practice disagree with you, as
> you well know.

Well that doesn't mean that the practice makes much sense.

Security (which is probably too strong a word for these relatively
weak DoS anyways; it's not like anybody's data gets leaked like
Alan hinted at with his bogus analogy) is only useful if it's perfect; if it 
has holes that cannot be plugged it is just wasted effort and likely 
harming other good causes (like bug free software) 
 
> > The printks are extremly
> > useful and have found many bugs in the past.
> 
> So you turn it on if your applications are playing up.  bfd.

You might not know applications are segfaulting. e.g. when I originally
enabled it we found that a few obscure cases in a default system
were occasionally segfaulting, but nobody noticed because there
wasn't a really visible malfunction. Still fixing those made
a better system.
 
> Still waiting for your report of all the other means by which unpriviliged
> users can spam the logs, btw.  Of course, your attitude here makes a
> mockery of all our other care and effort in this area.

One standard way is to overflow the socket limits or the TCP memory allocation 
for example. Or just run the system out of memory; that will get plenty of logs
(don't say ulimit now, you know as well as me that they are not good enough
to prevent oom from users). Or use an unaligned a.out executable.

That was just from a quick look, I'm sure there are more.

Some of these are rate limited, but rate limiting just means it will take longer
to fill the disk. 

There are also a couple (rate limited ones) that can be triggered from the network.

Anyways if you feel strongly about it then rate limit the x86-64 ones
(Masoud's patch did this anyways); but please don't turn them off.

-Andi
