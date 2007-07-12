Return-Path: <linux-kernel-owner+w=401wt.eu-S932158AbXGLSQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbXGLSQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 14:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbXGLSQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 14:16:39 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:4148 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbXGLSQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 14:16:37 -0400
Date: Thu, 12 Jul 2007 19:16:20 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andy Whitcroft <apw@shadowen.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, Mark Mason <mason@broadcom.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-mips@linux-mips.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-duart.c: SB1250 DUART serial support
In-Reply-To: <469669F5.6070906@shadowen.org>
Message-ID: <Pine.LNX.4.64N.0707121904211.3029@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0707121745010.3029@blysk.ds.pg.gda.pl>
 <469669F5.6070906@shadowen.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Andy Whitcroft wrote:

> > printk() should include KERN_ facility level
> > #750: FILE: drivers/serial/sb1250-duart.c:675:
> > +		printk(err);
> 
> Heh, yeah Ingo pointed this style out.  This is a wrapper where the
> facility will be supplied by the caller (I assume).  The thought there

 Actually "err" is "static const char *", except it is used twice in the 
function, so rather than cluttering the source with two identical strings 
and relying on GCC merging them I did it explicitly.

> was that only complain on printks which had a string literal as their
> first arguement.  That gets us very high accuracy and eliminates these
> falsies.

 That would be my suggestion too, if you asked me.  But as did not, I do 
not either.

> I think I tend to agree that the MAKEMASK ones are separate.  Good to
> see someone using their common sense in the face of whinging by the tool.

 Thanks for appreciation. ;-)

> WARNING: declaring multiple variables together should be avoided
> #372: FILE: drivers/serial/sb1250-duart.c:246:
> +	unsigned int mctrl, status;

 Well, this is probably superfluous -- why would anyone prefer:

	int r0;
	int r1;
	int r2;
	int r3;
	int r4;

to:

	int r0, r1, r2, r3, r4;

unconditionally?  I agree clustering variable declarations may obfuscate 
the code, but then again, a bit of common sense should be used.  It 
usually makes sense to group related variables together and declare other 
ones separately.

 And obviously if somebody writes unreadable code, then it is hard to 
change the habit with a script no matter how much you try.

  Maciej
