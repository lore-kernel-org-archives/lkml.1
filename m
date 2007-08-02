Return-Path: <linux-kernel-owner+w=401wt.eu-S1760933AbXHBV0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933AbXHBV0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 17:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbXHBV0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 17:26:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:50890 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752967AbXHBV0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 17:26:47 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX180LWAluF40Obxvr6qSSxIIgts7z9cCxuyajDZuws
	vcqwSLHTUY9qzf
Date: Thu, 2 Aug 2007 23:26:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <20070802210902.GQ21089@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.60.0708022317500.6774@poirot.grange>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
 <20070802200856.GO21089@ftp.linux.org.uk> <Pine.LNX.4.60.0708022223190.6774@poirot.grange>
 <20070802210902.GQ21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Al Viro wrote:

> On Thu, Aug 02, 2007 at 10:26:37PM +0200, Guennadi Liakhovetski wrote:
> > 
> > Worse yet, K&R explicitely writes:
> > 
> > <quote>
> > 
> > 	char pattern[] = "ould";
> > 
> > is a shorthand for the longer but equivalent
> > 
> > 	char pattern[] = { 'o', 'u', 'l', 'd', '\0' };
> > 
> > </quote>
> > 
> > In the latter spelling gcc < 4.2 DOES warn too.
> 
> Does warn for what?  Array with known size?  Sure, so it should - you
> have excess initializer list elements.
> 
> Note the [] in the quoted - it does matter.
> 
> Again, it's perfectly legitimate to use string literal to initialize
> any kind of array of character type.  \0 goes there only if there's
> space for it; if array size is unknown, the space is left.  That's it.

Sure. Doing 'char c[4] = "01234";' is just like doing '"0123"': only 
those bytes, for which there's space in the array go in, everything makes 
perfect sense. What doesn't make sense to me though, is that in the former 
case gcc warns, but not in the latter.

Maybe you're right in your interpretation of the standard / K&R, but it 
doesn't still make it logical to me, sorry. I always thought "0123" was 5 
bytes long (ok, ascii) and the terminating '\0' was an integral part of 
the string, no different from any other character, and not some optional 
token. Thus all the charecters should be handled equally.

Thanks
Guennadi
---
Guennadi Liakhovetski
