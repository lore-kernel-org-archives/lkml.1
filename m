Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXCSSSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXCSSSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 14:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbXCSSSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 14:18:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:50200 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbXCSSSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 14:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QXYIvkkgouLTqCBtSFyVmVcS3LqoCsnpqwAjnVph75rZ54xzw1nBxKkLanm6iWW6A32oeZCq1Y9OYKun04XvFCxc1y05WURhYhq8XcIjaWYW+PQCEZhR2ZbK1HygHBkYJQqZmNOFBq4YPQhuFARbrDl0cOFKFUjywbtGr92t0js=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH][1/5][resend] floppy.c: Initial (partial) CodingStyle cleanup
Date: Mon, 19 Mar 2007 19:18:38 +0100
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Trent Waddington <trent.waddington@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, jesper.juhl@gmail.com
References: <200703191610.13940.jesper.juhl@gmail.com> <20070319083159.0744cf5e.randy.dunlap@oracle.com>
In-Reply-To: <20070319083159.0744cf5e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703191918.39277.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2007 16:31:59 Randy Dunlap wrote:
> On Mon, 19 Mar 2007 16:10:13 +0100 Jesper Juhl wrote:
> >     This is a basic CodingStyle cleanup for drivers/block/floppy.c
[snip]
> >
> > -#define LAST_OUT(x) if (output_byte(x)<0){ reset_fdc();return;}
> > +#define LAST_OUT(x) if (output_byte(x) < 0) { reset_fdc(); return; }
>
> Not for a coding style cleanup, but that macro is Bad according to
> CodingStyle, so hopefully it will be cleaned up in the future.
>
Looking at each of the (many) macros in there is on my TODO list, but fixing 
macros was not the point of this patch.

[snip]
> > @@ -3816,7 +3803,7 @@ static int check_floppy_change(struct gendisk
> > *disk) */
> >
> >  static int floppy_rb0_complete(struct bio *bio, unsigned int bytes_done,
> > -			       int err)
> > +		int err)
>
> I don't care one way or the other about most of these, but would
> you explain that one above (and others like it), please?

Sure.

> It's not an < 80 columns thing.  My <cough> recollection is that
> many indented function parameters in Linux are indented more like
> the original here, near the opening '(' after the function name,
> although I suppose that none of this is in CodingStyle.
>

The reason behind the change is manyfold.

The first reason is consistency. Function parameters that span over more than 
one line should be indented identical for each such function in the file (and 
preferably across files as well).  The changes made by this patch make all 
such functions the same within floppy.c

The second reason is that indenting two tabs seems to make the most sense for 
a few reasons;  
	a) not indenting at all is ugly, plain and simple.
		void function(int a, int b,
		int c, int d, int e)
		{
			int foo;
			int bar;
		...
		}
	b) indenting only one tab stop puts parameters at the same indent level as
	   variables in the function which is potentially confusing (at least IMHO).
		void function(int a, int b,
			int c, int d, int e)
		{
			int foo;
			int bar;
		...
		}
	c) Indenting so that all parameter lines start at the opening paranthesis 
	   rarely matches up with tabs so you have to use varying amounts of spaces
	   depending on how long the function name is. Not a good solution IMHO.
		void function(int a, int b,
				     int c, int d, int e)
		{
			int foo;
			int bar;
		...
		}
	d) Indenting by two tab stops avoids the problems with a, b & c and also
	   avoids indenting so much so that the number of lines needed (when all
	   need to be kept <80 col) is not increased too much in most cases. 
		void function(int a, int b,
				int c, int d, int e)
		{
			int foo;
			int bar;
		...
		}

I also have a recollection (although I can't find the exact threads atm) that 
in the past the question of how to indent function parameters that span more 
than one line, settled on two tabs.

I hope that explains my reasons for making the change :-)

This should probably go into CodingStyle if some official consensus on this 
can be reached. 


-- 
 Jesper Juhl <jesper.juhl@gmail.com>

 
 
