Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbXJIWD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbXJIWD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 18:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbXJIWDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 18:03:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:55191 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbXJIWDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 18:03:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=DGWK/UlCh+P93HNj+ByisuHBTR9QntZNMhUNERwCBDOaPuDHDFZaYz+ALO6pTiB/1LGpQM8FTet5h8ufkw6/6QElLHxNL1VGTpq6Hw0+jCURp4ZbSEh/viFTAYxz9MdHSt1bmnp3dON2yoFsOUaYzhK24hQjcZRin9+AQcaInEM=
Date: Wed, 10 Oct 2007 00:03:31 +0200
To: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NTFS error messages: replace static char pointers by static char arrays
Message-ID: <20071009220331.GD11579@Ahmed>
References: <470AA75E.7010508@gmail.com> <20071009124035.GA4245@Ahmed> <20071009183359.GB3945@titan.lahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009183359.GB3945@titan.lahn.de>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 08:33:59PM +0200, Philipp Matthias Hahn wrote:
> Hello!
> 
> On Tue, Oct 09, 2007 at 02:40:35PM +0200, Ahmed S. Darwish wrote:
> > On Tue, Oct 09, 2007 at 01:55:42AM +0400, Dmitri Vorobiev wrote:
> > > The patch below contains a small code clean-up for the NTFS driver: all
> > > static char pointers to error message strings have been replaced by 
> > > static char arrays.
> 
>       char *       a = "a"; // pointer and content can be changed

Only the pointer can be changed here. AFAIK "a" is a const string.

> const char *       b = "b"; // the thing pointed to is const

The "const" here is redundant (just useful for forcing the compiler to
prevent us from shooting our feet). The "b" string is already constant.

>       char * const c = "c"; // the pointer is const
> const char * const d = "d"; // pointer and content can't be changed
> 
> void foo(void) {
>         *a = 'A';

This will segfault.

>         a++;
>         *b = 'B'; // error: assignment of read-only location
>         b++;
>         *c = 'C';

Last line will segfault too.

>         c++;      // error: increment  of read-only variable 'c'
>         *d = 'D'; // error: assignment of read-only location
>         d++;      // error: increment  of read-only variable 'd'
> }
> 

Please continue below.

> > Isn't the only difference between char *c = "msg" and char c[] = "msg" is 
> > that the first is a non-const pointer to a const char array while the second 
> > is a modifiable char array ?
> 
> $ cat [ab].c
> const char *a = "a";
> const char b[] = "b";
> $ gcc -c [ab].c
> $ size [ab].o
>    text    data     bss     dec     hex filename
>       2       4       0       6       6 a.o
>       2       0       0       2       2 b.o
> 
> 'a' has two entries: one for the named read-writeable pointer, and one for the
>     anonymous read-only string, the pointer points to.
> 'b' has a single entry: just the named read-only string.
> 

Got the point, Thanks!.

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
