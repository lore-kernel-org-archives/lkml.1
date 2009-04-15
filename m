Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbZDOGPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbZDOGPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZDOGOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:14:54 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1236 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZDOGOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:14:53 -0400
Subject: Re: RFC: introduce struct ksymbol
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090415055839.GA12040@elte.hu>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
	 <1239771791.32241.6.camel@localhost>  <20090415055839.GA12040@elte.hu>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 23:14:11 -0700
Message-Id: <1239776051.32241.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 07:58 +0200, Ingo Molnar wrote:
> (Sam and Rusty Cc:-ed)
> > Perhaps a conversion from
> > 
> > "char str[KSYM_SYMBOL_LEN]"
> > to
> > "struct ksymbol sym"?
> > 
> > could be useful.
> > 
> > There are a few places that use a hard coded length of 128
> > instead of KSYM_SYMBOL_LENGTH that are also converted.
> > 
> > Compile tested only
> 
> Why not 'struct ksym'? That name is unused right now, it is shorter 
> and just as descriptive.

Either's ok with me.

> Downsides would be loss of awareness of stack footprint impact. A 
> plain struct is easy to slap on, and it's not immediately visible 
> that it carries 128 bytes of weight.

Stack footprint with KSYM_SYMBOL_LEN isn't very apparent.
KSYM_SYMBOL_LEN is more than 200.

 #define KSYM_NAME_LEN 128
 #define KSYM_SYMBOL_LEN (sizeof("%s+%#lx/%#lx [%s]") + (KSYM_NAME_LEN - 1) + \
                         2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
> It might also be confusing in 
> terms of the nature of the interface - whether it's a pointery 
> object or not.

Specified type makes it hard to pass the wrong
sized buffer.

> Prior use:
>         char str[KSYM_SYMBOL_LEN];
>         kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> New use:
> 	struct ksym sym;
> 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, &sym);

cheers, Joe

