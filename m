Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbXHBXJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbXHBXJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757177AbXHBXJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:09:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59473 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbXHBXJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:09:18 -0400
Date: Fri, 3 Aug 2007 00:09:15 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
Message-ID: <20070802230914.GT21089@ftp.linux.org.uk>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange> <46B25B5E.30406@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030046230.6774@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0708030046230.6774@poirot.grange>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 12:51:16AM +0200, Guennadi Liakhovetski wrote:
> On Fri, 3 Aug 2007, Stefan Richter wrote:
> 
> > Guennadi Liakhovetski wrote:
> > > with
> > > 
> > > 	char c[4] = "012345";
> > > 
> > > the compiler warns, but actually allocates a 6-byte long array...
> > 
> > Off-topic here, but:  sizeof c / sizeof *c == 4.
> 
> Don't think it is OT here - kernel depends on gcc. And, what I meant, is, 
> that gcc places all 7 (sorry, not 6 as I said above) characters in the 
> .rodata section of the compiled object file. Of course, it doesn't mean, 
> that c is 7 characters long.

So gcc does that kind of recovery, after having warned you.  Makes sense,
as long as it's for ordinary variables (and not, say it, struct fields) -
you get less likely runtime breakage on the undefined behaviour (e.g.
passing c to string functions).  So gcc has generated some padding between
the global variables, that's all.

It doesn't change the fact that use of c[4] or strlen(c) or strcpy(..., c)
means nasal demon country for you.

Now, if gcc does that for similar situation with struct fields, you'd have
a cause to complain.
