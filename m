Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYAIOlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYAIOlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYAIOlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 09:41:13 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:65108 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYAIOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 09:41:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U1rkYJS0QMpoWmMhxUujgEbAEBPHN7d1VBDZVqHvPGYow8214z6juBrs4UzzAYmM2oqWkEJJ6MLHrJYzs9Md3zAhonmnaX/wClCGOWgdwV1rzTi5yG6qz9bAH733gXQ50cilIbyc+THS/wUzRrSDCAXZEh9oF5IbxWQOQ8wTLgI=
Message-ID: <9a8748490801090641s41a06c1era3764091f135567d@mail.gmail.com>
Date: Wed, 9 Jan 2008 15:41:11 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Anton Salikhmetov" <salikhmetov@gmail.com>
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, joe@evalesco.com
In-Reply-To: <4df4ef0c0801090332y345ccb67se98409edc65fd6bf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199728459.26463.11.camel@codedot>
	 <4df4ef0c0801090332y345ccb67se98409edc65fd6bf@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2008, Anton Salikhmetov <salikhmetov@gmail.com> wrote:
> Since no reaction in LKML was recieved for this message it seemed
> logical to suggest closing the bug #2645 as "WONTFIX":
>
> http://bugzilla.kernel.org/show_bug.cgi?id=2645#c15
>
> However, the reporter of the bug, Jacob Oestergaard, insisted the
> solution to be resubmitted once more:
>

Good idea. The bug is real and should be fixed IMHO.


...
> This bug causes backup systems to *miss* changed files.
>
> This bug does cause data loss in common real-world deployments (I gave an
> example with a database when posting the bug, but this affects the data from
> all mmap using applications with common backup systems).
>
Not just backup systems, but any application that relies on mtime
being correctly updated will be bitten by this.


> Silent exclusion from backups is very very nasty.
>
Agreed.

In fact if mtime is not reliable (which it is not) one could argue
that we might as well not update it at all, ever. But I think we can
all agree that just fixing it (as your patch does) is a lot better.

> Please comment on my solution or commit it if it's acceptable in its
> present form.
>
I've only looked briefly at your patch but it seems resonable. I'll
try to do some testing with it later.

Thank you for working on this long standing bug.

...
> > I would like to propose my solution for the bug #2645 from the kernel bug tracker:
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=2645
> >
> > The Open Group defines the behavior of the mmap() function as follows.
> >
> > The st_ctime and st_mtime fields of a file that is mapped with MAP_SHARED
> > and PROT_WRITE shall be marked for update at some point in the interval
> > between a write reference to the mapped region and the next call to msync()
> > with MS_ASYNC or MS_SYNC for that portion of the file by any process.
> > If there is no such call and if the underlying file is modified as a result
> > of a write reference, then these fields shall be marked for update at some
> > time after the write reference.
> >
> > The above citation was taken from the following link:
> >
> > http://www.opengroup.org/onlinepubs/009695399/functions/mmap.html
> >
...

I agree that our current behaviour is certainly not what the standard
(sensibly) requires.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
