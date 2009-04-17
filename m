Return-Path: <linux-kernel-owner+w=401wt.eu-S1759874AbZDQH4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874AbZDQH4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZDQH4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:56:11 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4328 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbZDQH4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:56:10 -0400
Subject: Re: RFC: introduce struct ksymbol
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200904152021.41427.rusty@rustcorp.com.au>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
	 <1239771791.32241.6.camel@localhost> <20090415055839.GA12040@elte.hu>
	 <200904152021.41427.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 00:55:33 -0700
Message-Id: <1239954933.31728.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 20:21 +0930, Rusty Russell wrote: 
> On Wed, 15 Apr 2009 03:28:39 pm Ingo Molnar wrote:
> > Why not 'struct ksym'? That name is unused right now, it is shorter 
> > and just as descriptive.
> > 
> > Regarding the change... dunno. Sam, Rusty - what do you think?
> 
> Yes, ksym is nice.  But agree with you that it's marginal obfuscation
> to wrap it in a struct.
> 
> The current symbol printing APIs are awful; we should address them first
> (like the %pF patch does) IMHO.

I suggest just %pS<type>

With %pS, struct ksym is probably not all that
useful unless it's for something like a sscanf.

Today there are these symbol uses:
name, offset, size, modname

So perhaps %pS<foo> where foo is any combination of:

n name
o offset
s size
m modname
a all

and if not specified is a name lookup ("%pSn").


