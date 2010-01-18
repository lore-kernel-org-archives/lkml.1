Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931Ab0ARK7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0ARK7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 05:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883Ab0ARK7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 05:59:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab0ARK7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 05:59:09 -0500
Message-ID: <4B543EF2.50605@suse.cz>
Date: Mon, 18 Jan 2010 11:58:58 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
Cc: linux-kbuild@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Julia Lawall <julia@diku.dk>, Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>, stefanr@s5r6.in-berlin.de,
       adi@hexapodia.org, david.vrabel@csr.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, cocci@diku.dk,
       Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Palix <npalix@diku.dk>
Subject: Re: SmPL scripts into build environment?
References: <4B502C6B.7000802@s5r6.in-berlin.de> <20100115.005445.263291449.davem@davemloft.net> <tkrat.e88dd4dbf17f9bde@s5r6.in-berlin.de> <20100115.012233.202457727.davem@davemloft.net> <Pine.LNX.4.64.1001151039080.23543@ask.diku.dk> <84144f021001150149u3b784d26g1822be6c5c3ecbf@mail.gmail.com> <Pine.LNX.4.64.1001151101320.23543@ask.diku.dk> <20100115110845.GB28625@sirena.org.uk> <Pine.LNX.4.64.1001151303580.23543@ask.diku.dk> <20100115133933.GB21188@rakim.wolfsonmicro.main> <4B509C90.10305@freemail.hu>
In-Reply-To: <4B509C90.10305@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.1.2010 17:49, Németh Márton wrote:
> Hi Marek,

s/Marek/Michal/ :)


> there was a discussion about patches which are generated using the
> tool called spatch. In the changelog the SmPL script was usually
> included, see http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git&a=search&h=HEAD&st=commit&s=%3Csmpl%3E .
> It is useful to store the SmPL scripts because they may find
> problems in the newcoming code also.
> 
> In order to run a "check" the spatch tool and the SmPL is also necessary.
> There was an idea to place the used SmPL scripts under the Linux
> kernel source tree so it can move from the changelog but still remain
> for later use. The "check" could be run similar to the tools checkpatch,
> sparse or lockdep.
> 
> What do you think where the SmPL scripts can be placed?

Documentation/smpl/$name_of_problem_fixed.cocci? Or maybe better
scripts/smlp/..., if you are going to add some wrapper that runs the
semantic patches on the source tree. Or something like that, a dedicated
subdirectory to store the semantic patches in individual files.


> What do you think the best way would be to introduce some check like this
> in the build environment?

I've only heard about the tool, I haven't used it yet. Does it need to
preprocess and parse source files like sparse does, or can it check C
files without expanding macros and includes? If the former, then let's
extend make C=... to also support spatch. If the latter, then a script
that runs spatch on all *.c files found the tree should be enough. But
as I said, I haven't used the tool, so I don't know what it needs and
what it can offer.

Michal
