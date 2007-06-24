Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXFXXAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXFXXAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFXXAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:00:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbXFXXAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:00:23 -0400
Date: Sun, 24 Jun 2007 16:00:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Richard Henderson" <rth@tamu.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid potential NULL deref in scripts/genksyms/lex.l
Message-Id: <20070624160014.84e26d35.akpm@linux-foundation.org>
In-Reply-To: <9a8748490706241502j217a5c6drd015dcd84633ab3a@mail.gmail.com>
References: <200706242340.03871.jesper.juhl@gmail.com>
	<20070624145837.f3141572.akpm@linux-foundation.org>
	<9a8748490706241502j217a5c6drd015dcd84633ab3a@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007 00:02:03 +0200 "Jesper Juhl" <jesper.juhl@gmail.com> wrote:

> > > +      if (!file || !e)
> > > +     exit(1);
> > >        *e = '\0';
> > >        cur_filename = memcpy(xmalloc(e-file+1), file, e-file+1);
> > >        cur_line = atoi(yytext+2);
> >
> > I don't think the bug which you're fixing can occur:
> >
> > ^#[ \t]+{INT}[ \t]+\"[^\"\n]+\".*\n     return FILENAME;
> >
> > has anyone reported crashes in there?
> >
> 
> It may indeed not be possible. Found by inspection, not by any actual
> observed crashes.
> But does it really hurt to be defensive here? In case it can somehow
> be caused to fail, with my patch it'll fail a bit nicer :) It's not
> like it's at all speed critical code that will be hurt by that extra
> 'if'...

We can only get NULL pointers here if the regexp is wrong or if there's
a bug in the regexp parser.  Getting a coredump at the failure site is
much better behaviour than mysteriously exiting.
