Return-Path: <linux-kernel-owner+w=401wt.eu-S1758298AbYEFGTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298AbYEFGTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbYEFGTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:19:36 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48685 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828AbYEFGTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:19:35 -0400
Date: Tue, 6 May 2008 09:18:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
Message-ID: <20080506061825.GF1544@cs181133002.pp.htv.fi>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu> <874p9ccmes.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <874p9ccmes.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 02:21:31AM +0200, Andi Kleen wrote:
> 
> I don't think the code changes actually with current gcc for integer
> code if you change something from global to static (unless it causes
> gcc to inline the function, but then it might be well larger if you're
> unlucky)

It's a common case that a function has only one caller. It should always 
be an (at least tiny) space win to get them inlined.

> The only file size change you'll see will be from a smaller symbol
> table in the vmlinux ELF file, but that is not even loaded at run time
> or included into the bzImage (and the kallsyms table has statics too)
>...

I'm not attaching size change information to these patches since 
whatever change one sees anyway also depends on other factors like
the exact kernel configuration, so it's non-trivial to get numbers
that could be taken seriously.

There are many small aspects, e.g. both gcc with -Wmissing-prototypes 
and sparse give warnings, and the problem might either be needlessly 
global code or the fact that a function prototype is either not in a 
header or the header not #include'd by the file. Although I've only
2 or 3 times catched such bugs in the kernel that is a nasty to debug 
class of bugs and gcc can find such problems at compile time.

> I could see some advantage from static in future compiler versions 
> though from better optimization, but it's quite remote.
>...

The best case I've actually seen in practice was a variable I made 
static, and with CONFIG_DEBUG_FOOBAR=n gcc was now able to prove that 
the value never changed resulting in the variable plus quite a chunk
of code no longer emitted.

> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

