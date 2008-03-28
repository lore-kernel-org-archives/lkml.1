Return-Path: <linux-kernel-owner+w=401wt.eu-S1756516AbYC1VEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbYC1VEO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYC1VD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:03:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:36796 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474AbYC1VD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:03:58 -0400
Date: Fri, 28 Mar 2008 22:04:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: use of volatile in iounmap()?
Message-ID: <20080328210422.GA14484@uranus.ravnborg.org>
References: <20080328203427.GA14256@uranus.ravnborg.org> <47ED5A40.9020307@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47ED5A40.9020307@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 01:51:12PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >While reviewing some CAN driver I stumbled on iounmap
> >which has following prototype on x86:
> >
> >extern void iounmap(volatile void __iomem *addr);
> >
> >I argued that the driver should not use volatile
> >but then I cannot explain why the argument to
> >iounmap takes a volatile.
> >
> >The same goes for many other functions in
> >the io*.h headers.
> >
> >Grepping the other archs they mostly follow
> >same pattern.
> >
> >Can anyone explain the rational for volatile in this case.
> >
> 
> Yes.  The use of volatile in a function prototype like this means that 
> it is valid to pass a volatile pointer to that function -- in other 
> words, we're telling gcc that we're not going to do anything with the 
> pointer that is invalid for a volatile pointer.
If I understand you correct then it is then not wrong to say
that we have the argument volatile to avoid warnings from gcc
when we pass a volatile pointer.

And then having the pointer marked volatile put a few restrictions
on iounmap().

> 
> A lot of the "volatile considered harmful" stuff that has been bandied 
> about is explicitly about marking *data* items volatile (it does have 
> its uses, but it's easy to get wrong); Linus has explicitly made the 
> distinction between volatile *data* and volatile *operations*.

Yes - but unfortunately the volatile-considered-harmful.txt
does many deal with the data part.

Thanks,
	Sam
