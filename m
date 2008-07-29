Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbYG2Qgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbYG2Qgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYG2Qgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:36:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbYG2Qgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:36:35 -0400
Date: Tue, 29 Jul 2008 09:33:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: Re: linux-next: build failure
In-Reply-To: <20080729114029.GA3836@elte.hu>
Message-ID: <alpine.LFD.1.10.0807290927240.3334@nehalem.linux-foundation.org>
References: <20080729180317.94c64634.sfr@canb.auug.org.au> <20080729085815.GA1301@elte.hu> <20080729202731.F18F.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080729114029.GA3836@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Jul 2008, Ingo Molnar wrote:
> 
> the fix is simple enough.
> 
> but the question is, wont it generate huge artificial stackframes with 
> CONFIG_MAXSMP and NR_CPUS=4096?

Quite the reverse.

The "address-of statement expression" is the one that is more likely to 
generate artificial stack-frames because of a temporary variable (of 
course, I wouldn't count on it, since statement expressions are gcc 
extensions, and as such the gcc people could make up any semantics they 
want to them, including just defining that a statement expression with 
an lvalue value is the same lvalue rather than any temporary). 

In contrast, "address-of lvalue" is _guaranteed_ to not do anything stupid 
like that, and gives just the address-of.

Oh, and I was wrong about the &*x losing the 'const'. It doesn't. So I 
think Stephen's patch is fine after all - if somebody tries to modify the 
end result through the pointer, it will give a big compiler warning.

			Linus
