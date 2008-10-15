Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYJORPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYJORPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYJORPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:15:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbYJORPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:15:25 -0400
Date: Wed, 15 Oct 2008 10:09:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
cc: Adrian Bunk <bunk@kernel.org>, zippel@linux-m68k.org, sam@ravnborg.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [2.6 patch] HID: fix default building of all quirky devices
In-Reply-To: <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz>
Message-ID: <alpine.LFD.2.00.0810151002120.3288@nehalem.linux-foundation.org>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi> <20081015073011.GE20183@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 15 Oct 2008, Jiri Kosina wrote:
> 
> Hmm ... I am not really sure, isn't this a bug in Kconfig?

Not really, more of a misfeature.

That said, even if we were to consider it a bug, Adrian's patch is 
obviously the better way to do it. You shouldn't do non-local dependencies 
(have one config option select fifty other ones), when the local ones are 
clearer and more readable (have one config option just describe its *own* 
dependencies).

Don't get me wrong - select is very useful, but not for "should I ask this 
question or not". The point to use select is when you have some library or 
other common infrastructure that isn't worth a question of its own (eg 
"Why the hell would the user want to care whether he needs CRC32 
routines?"), and some code says "I will need this infrastructure" by just 
saying "select CRC32" to let the build system know that it needs that 
particular piece of functionality.

In other words, "select" is kind of a "depends on", but for things that it 
is insane to ask. It would be totally _idiotic_ to ask a user "do you want 
to have CRC32 routines in the kernel?" and then based on that say "ok, you 
didn't ask for CRC32, so now you cannot use the AX88796 network driver".

See? THAT is what "select" is for. And when you use select, the way we do 
things now, you have to select everything you need. You cannot assume that 
it will recursively select whatever it needs.

And notice how you mis-use select. That's not how to disable a question. A 
question gets disabled by just doing an "if xyz" on the question itself, 
like Adrian did.

			Linus
