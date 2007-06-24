Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbXFXXIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbXFXXIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXFXXI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:08:28 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:17911 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXFXXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:08:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ecrXpJTYG5H3v/E6LpklRlUFzxEk1L4Y2nS5SYbcnSl7Clg88MKNprufZ2s6BXEtrCT1rRrKwT3QvDFBZF+OHbVhQVOvX9QbPRYL+chghLWu274RAfJ4d5eY++rEAxdbu/Tb93sVOpIBqBnZIaJ/x8N0UYZ3MgI/CgfjVTGVY3U=
Message-ID: <9a8748490706241608r6814463fl997e36c8916f7561@mail.gmail.com>
Date: Mon, 25 Jun 2007 01:08:27 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Avoid potential NULL deref in scripts/genksyms/lex.l
Cc: "Richard Henderson" <rth@tamu.edu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070624160014.84e26d35.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706242340.03871.jesper.juhl@gmail.com>
	 <20070624145837.f3141572.akpm@linux-foundation.org>
	 <9a8748490706241502j217a5c6drd015dcd84633ab3a@mail.gmail.com>
	 <20070624160014.84e26d35.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 25 Jun 2007 00:02:03 +0200 "Jesper Juhl" <jesper.juhl@gmail.com> wrote:
>
> > > > +      if (!file || !e)
> > > > +     exit(1);
> > > >        *e = '\0';
> > > >        cur_filename = memcpy(xmalloc(e-file+1), file, e-file+1);
> > > >        cur_line = atoi(yytext+2);
> > >
> > > I don't think the bug which you're fixing can occur:
> > >
> > > ^#[ \t]+{INT}[ \t]+\"[^\"\n]+\".*\n     return FILENAME;
> > >
> > > has anyone reported crashes in there?
> > >
> >
> > It may indeed not be possible. Found by inspection, not by any actual
> > observed crashes.
> > But does it really hurt to be defensive here? In case it can somehow
> > be caused to fail, with my patch it'll fail a bit nicer :) It's not
> > like it's at all speed critical code that will be hurt by that extra
> > 'if'...
>
> We can only get NULL pointers here if the regexp is wrong or if there's
> a bug in the regexp parser.  Getting a coredump at the failure site is
> much better behaviour than mysteriously exiting.
>
Fair enough. Just ignore the patch then :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
