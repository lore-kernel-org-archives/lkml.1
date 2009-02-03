Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZBCS7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZBCS7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 13:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBCS7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 13:59:36 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:57151 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751472AbZBCS7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 13:59:36 -0500
Date: Tue, 3 Feb 2009 21:59:33 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: On PowerPC we don't need frame pointers for
	CALLER_ADDRs
Message-ID: <20090203185933.GA9878@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090131190650.GA4284@oksana.dev.rtsoft.ru> <1233534919.18767.69.camel@pasglop> <1233583455.16878.3.camel@localhost.localdomain> <20090203145649.GA19955@oksana.dev.rtsoft.ru> <20090203160645.GA9020@elte.hu> <20090203161955.GA776@oksana.dev.rtsoft.ru> <1233678738.16878.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <1233678738.16878.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 11:32:18AM -0500, Steven Rostedt wrote:
> 
> On Tue, 2009-02-03 at 19:19 +0300, Anton Vorontsov wrote:
> > On Tue, Feb 03, 2009 at 05:06:45PM +0100, Ingo Molnar wrote:
> 
> > [1] Btw, why exactly do we need the -fno-omit-frame-pointer for
> > "FUNCTION_TRCER" tracer? Why just -pg isn't sufficient?..
> > 
> 
> The problem is this that is in the toplevel Makefile:
> 
> 
> ifdef CONFIG_FRAME_POINTER
> KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
> else
> KBUILD_CFLAGS	+= -fomit-frame-pointer
> endif
> 
> 
> -pg is incompatible with -fomit-frame-pointer

Ah...

$ gcc -pg -fomit-frame-pointer -S c.c
gcc: -pg and -fomit-frame-pointer are incompatible

It's hard-coded in gcc, in the code that don't know about
architecture details.

But on PowerPC -O1 implies -fomit-frame-pointer, that is

gcc -pg -O1 -fno-omit-frame-pointer
and
gcc -pg -O1

produce different outputs. Thus -pg -O should be the same
as "-pg -O -fomit-framepointer".

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
