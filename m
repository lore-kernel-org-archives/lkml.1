Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbXBSOt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbXBSOt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:49:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932303AbXBSOt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:49:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:23380 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbXBSOt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:49:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=SaGekI6CYMzzl2QXqVaaAsudD/e7m8U7qmmhK7q3iQqvLmw0emJPPUaAvLnWGRVe8LyQQgItvYRvBcuUspc9iEIkPc3mgNA1qeZE/hutvf7VxRcORCpkjDK2UAlw08Peu1Ns5NIyZoALOfOcqXqkArQ1BBdUxhC4HNVXFOR9Fwo=
Date: Tue, 20 Feb 2007 14:48:14 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: rmk+lkml@arm.linux.org.uk
Cc: jose.goncalves@inov.pt, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070220144814.GJ566@slug>
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219143520.GB27370@flint.arm.linux.org.uk>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(trimmed tie-fei.zang from the CC, added by mistake)
On Mon, Feb 19, 2007 at 02:35:20PM +0000, Russell King wrote:
> > Neither did I, but introducing printk's through the function, we narrowed
> > the problem to this part of the code. And removing it makes the problem
> > go away. We inserted 37 printk's in the function body, and Jose bisected
> > those until the problem went away.
> 
> Well, there's still little clue about why this is causing a NULL pointer
> dereference.  The only thing I can think is that somehow performing
> this test is causing a power glitch to your CPU, causing its registers
> to get corrupted, and which results in it doing a NULL pointer deref.
That may be the case, indeed.
> 
> Are you saying that the NULL pointer occurred while executing this code?
> If not, where does the NULL pointer occur?
The thing is, the NULL pointer deref dissapeared as soon as we
instrumented (printk'ed) the code. So it's seems to be triggered by
check+timing+hardware.
> 
> > > No, it's only runtime because you can't tell which ports might be
> > > affected, and you might have a mixture of ports which are affected
> > > and those which aren't.
> > Hmm, ok. And what about a CONFIG_I_KNOW_MY_SERIAL_IS_BROKEN option?
> 
> Andrew's said no (in that the thread you refer to) and suggested an
> alternative, I've said no, how many more 'no's do you need to turn
> you away from the wrong approach?
One is usually sufficient once I've understood :). I missed the module
option approach. Is it ok with you? If yes, I'll put up a patch to do
this.
> 
> > > > PS: CCing Andrew and Zang Roy-r61911 as they seemed to discuss this in
> > > > http://lkml.org/lkml/2006/6/13/21
> > > 
> > > I don't see any reference to this problem there.
> >
> > Sorry, I suck, I got that mixed with that one:
> > http://lkml.org/lkml/2006/12/26/63
> > "probing for UART_BUG_TXEN in 8250 driver leads to weird effects on some
> > ARM boards"
> 
> The "weird effects" were never quantified, so that's one of the reasons
> I ignored that report (another being is that I stopped being the serial
> maintainer a while ago, and now serial is maintainerless.)
> 
The problem appears to be reproducible on Jose's hardware within 2-3 days.
If you see other tests to be performed...

Regards,
Frederik
