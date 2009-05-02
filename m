Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbZEBAPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbZEBAPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 20:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757754AbZEBAOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 20:14:45 -0400
Received: from ru.mvista.com ([213.79.90.228]:7166 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760863AbZEBAOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 20:14:44 -0400
Date: Sat, 2 May 2009 04:14:43 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] powerpc, Makefile: Make it possible to safely
	select CONFIG_FRAME_POINTER
Message-ID: <20090502001443.GA2762@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090320164404.GA19933@oksana.dev.rtsoft.ru> <20090320164429.GA28037@oksana.dev.rtsoft.ru> <20090405210756.GG24374@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090405210756.GG24374@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 05, 2009 at 11:07:56PM +0200, Sam Ravnborg wrote:
> On Fri, Mar 20, 2009 at 07:44:29PM +0300, Anton Vorontsov wrote:
> > This patch introduces ARCH_HAS_NORMAL_FRAME_POINTERS Kconfig symbol.
> > When defined, the top level Makefile won't add -fno-omit-frame-pointer
> > cflag (the flag is useless in PowerPC kernels, and also makes gcc
> > generate wrong code).
> > 
> > Also move ARCH_WANT_FRAME_POINTERS's help text.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> 
> Hi Anton - sorry for the late feedback.
> 
> 1) The preferred naming for variables that are supposed to be selcted
>    are "HAVE_xxxx".
>    So in this case it would be:
>    HAVE_NORMAL_FRAME_POINTER

OK, will rename.

> 2) I do not really understand the interpretation of normal in this case,
>    can it be more specific?

Normal means that architecture's ABI implies having a framepointer,
we don't need any gcc flags.

I'm not sure if we can name it any better, that is what was
suggested by Steven and I don't have any better variant. ;-)

>    Looking at your patch then if specified we use "-fomit-frame-pointer"
>    in the case where it is set.

No. We specify neither -fomit-frame-pointer, nor we specify
-fno-omit-frame-pointer (because that flag causes gcc to generate
wrong code).

>    So I read it like:
> 
>       If arch has normal framepointer then we omit them - strange?
> 
> 3) Indent in top-level MAkefile for new stuff is generally 8 spaces.
>    Do NOT use tabs as this would confuse make and rener assignmnet non-functional.
> 
> 4) The individual "HAVE_* members should be sorted alphabetically in the arch
>    Kconfig file (which they seldomly are :-( )
> 
> 	Sam

Well, yes. So looking into the Kconfig, I'm quite unsure where
to put it to make it alphabetically correct. Ok, let's put
it after K. ;-)

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
