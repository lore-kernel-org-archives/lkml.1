Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbZJFSSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbZJFSSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933037AbZJFSSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:18:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933020AbZJFSSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:18:08 -0400
Date: Tue, 6 Oct 2009 11:16:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Len Brown <lenb@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <alpine.LFD.2.00.0910061311460.7229@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0910061059100.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
 <alpine.LFD.2.00.0910061311460.7229@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Len Brown wrote:
> 
> This also means that I've overwritten all of the
> reference build results.

That was a really long and boring email, and all it said to me was

 "I can't be bothered to turn on CONFIG_LOCALCONFIG_AUTO, or I didn't even 
  read the thread to find out it exists and that you can use it even 
  without a git tree"

> thanks for listening.

I wish I could say the same.

So now, can you please just turn on CONFIG_LOCALCONFIG_AUTO and say "oh, 
I'm happy now"?

It really does work with tar-balls too. The whole tar-ball thing is a 
total red herring. All you need to do is add a ".scmversion" file into the 
end result, and you're done.

And you can do that easily - even _after_ you've created the tar-file, and 
even if you don't have a working tree. Lookie here:

	tar rvf some-random-tar-file.tar linux-x.y.z/.scmversion

see?

Or, in the case of using "git archive", you can avoid having to remember 
to add that .scmversion file, and instead teach your build-bot to create 
it automatically from the tar-file even if you do _not_ add a .scmversion 
file to the actual tar-file. "git tar" There's a command for that: "git 
get-tar-commit-id", so you can just add something like

	zcat < xxx.tar.gz | git get-tar-commit-id > .scmversion

(yes, yes, you may want to massage it a bit, ie do something like

	sed 's/^\(........\).*$/-g\1/'

or whatever to turn that 40-character SHA1 into a nicer extraversion. 
Whatever. Truly trivial scripting, and it means that your build server 
will now _always_ build a kernel that actually knows what kernel it is!

Isn't that the sign of a _good_ solution? Something that actually improves 
the end result in a real way? Now your builds will know what version they 
were built from!

Please?

		Linus
