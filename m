Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYEFAVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYEFAVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbYEFAVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:21:35 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:37993 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbYEFAVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:21:34 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Alexander Viro <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
From: Andi Kleen <andi@firstfloor.org>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi>
	<20080505201906.GA900@elte.hu>
Date: Tue, 06 May 2008 02:21:31 +0200
In-Reply-To: <20080505201906.GA900@elte.hu> (Ingo Molnar's message of "Mon, 5 May 2008 22:19:06 +0200")
Message-ID: <874p9ccmes.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 May 2008 00:14:35.0406 (UTC) FILETIME=[2A4B9AE0:01C8AF0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> But the per patch benefit is arguably extremely low: for example this 
> particular patch saves 0.00016% from my particular vmlinux's size.

I don't think the code changes actually with current gcc for integer
code if you change something from global to static (unless it causes
gcc to inline the function, but then it might be well larger if you're
unlucky)

The only file size change you'll see will be from a smaller symbol
table in the vmlinux ELF file, but that is not even loaded at run time
or included into the bzImage (and the kallsyms table has statics too)

So if we follow that "smaller symbol table" is better model
should we make a rule that all globals be 8 characters only? Or perhaps 6?  @)
I'm sure that could be easily enforced by some tool... 

I could see some advantage from static in future compiler versions 
though from better optimization, but it's quite remote.

I agree with your point that it's not effective to spend human time
to generate such patches.

-Andi
