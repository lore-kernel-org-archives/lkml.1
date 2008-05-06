Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbYEFLNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbYEFLNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbYEFLNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:13:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60798 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYEFLNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:13:08 -0400
Message-ID: <48203D3D.6000103@firstfloor.org>
Date: Tue, 06 May 2008 13:13:01 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
References: <20080505182942.GA17139@cs181133002.pp.htv.fi> <20080505201906.GA900@elte.hu> <874p9ccmes.fsf@basil.nowhere.org> <20080506061825.GF1544@cs181133002.pp.htv.fi>
In-Reply-To: <20080506061825.GF1544@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Tue, May 06, 2008 at 02:21:31AM +0200, Andi Kleen wrote:
>> I don't think the code changes actually with current gcc for integer
>> code if you change something from global to static (unless it causes
>> gcc to inline the function, but then it might be well larger if you're
>> unlucky)
> 
> It's a common case that a function has only one caller. It should always 
> be an (at least tiny) space win to get them inlined.

At least for the scheduler patch that started this thread this was not
the case. One was a global variable and the other was a callback from
proc. Both cannot be inlined.

> There are many small aspects, e.g. both gcc with -Wmissing-prototypes 
> and sparse give warnings, and the problem might either be needlessly 
> global code or the fact that a function prototype is either not in a 
> header or the header not #include'd by the file. Although I've only
> 2 or 3 times catched such bugs in the kernel that is a nasty to debug 
> class of bugs and gcc can find such problems at compile time.

Yes it's good to catch those. However I suspect there are better tools
for that that do it less work intensive. Traditionally in the Unix
world "lint" has been used to track this kind of bugs (dating back from
before prototypes were added to C). Now running any lint over the kernel
source would result in a incredibly number of warnings I'm sure, but
perhaps one can be configured to only output warnings related to
inconsistent prototypes over files. There are a couple of free lints
like the one in NetBSD or splint.	

>> I could see some advantage from static in future compiler versions 
>> though from better optimization, but it's quite remote.
>> ...
> 
> The best case I've actually seen in practice was a variable I made 
> static, and with CONFIG_DEBUG_FOOBAR=n gcc was now able to prove that 
> the value never changed resulting in the variable plus quite a chunk
> of code no longer emitted.

Sounds like the variable should just have been removed then in the source?

-Andi
