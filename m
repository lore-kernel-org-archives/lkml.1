Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbXLCSq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbXLCSq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 13:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXLCSqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 13:46:22 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:20000 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbXLCSqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 13:46:21 -0500
Subject: Re: [PATCH] isapnp driver semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org
In-Reply-To: <20071203164751.GB16135@elte.hu>
References: <20071203153743.119714913@mvista.com>
	 <20071203155753.GA32546@elte.hu>
	 <1196697144.1568.1.camel@jnielson-xp.ddns.mvista.com>
	 <20071203164751.GB16135@elte.hu>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 10:35:01 -0800
Message-Id: <1196706902.1568.11.camel@jnielson-xp.ddns.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-03 at 17:47 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Mon, 2007-12-03 at 16:57 +0100, Ingo Molnar wrote:
> > > * Daniel Walker <dwalker@mvista.com> wrote:
> > > 
> > > > Changed the isapnp semaphore to a mutex.
> > > 
> > > cool - i'll give it a whirl.
> > > 
> > > small immaterial nit:
> > > 
> > > > Signed-Off-By: Daniel Walker <dwalker@mvista.com>
> > > 
> > > it's Signed-off-by (note the capitalization). Having this consistent 
> > > makes scripting around patches a tiny bit easier.
> > 
> > Yeah, I know about it but sometimes still slips by..
> 
> it's worth automating these repetative bits. I use small templates when 
> creating patches. Also, it's worth running patches through 
> scripts/checkpatch.pl - it has a check for exactly this typo. [ Not a 
> big issue at all, i just mentioned it in case you get a taste for 
> sending more sem2mutex patches :-) ]
> 

Speaking of automating.. I created a little .vimrc add-on which helps
doing sem2mutex type changes. Here's the chunk I added,

    function Semtomutex( lo )
        exe '%s/down(&'.a:lo.')/mutex_lock\(\&'.a:lo.'\)/g'
        exe '%s/down_trylock(&'.a:lo.')/mutex_trylock\(\&'.a:lo.'\)/g'
        exe '%s/up(&'.a:lo.')/mutex_unlock\(\&'.a:lo.'\)/g'
        exe '%s/DECLARE_MUTEX('.a:lo.')/DEFINE_MUTEX\('.a:lo.'\)/g'
    endfunction
    map <C-\>o :call Semtomutex("<c-r><c-w>")<CR>


I just finished this about 30 seconds ago, and although I tested it once
I would guess it might have some bugs.. If you add it to your .vimrc ,
then you move your cursor over the lock name and hit Ctrl-\-o ,it will
convert all the calls for that lock name.. The list of calls it converts
isn't complete tho (down, down_trylock, and up) ..

I hope people still review the lock usage tho, since it's critical.

Daniel

