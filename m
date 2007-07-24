Return-Path: <linux-kernel-owner+w=401wt.eu-S1762520AbXGXRPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520AbXGXRPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXGXRO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:14:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34406 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbXGXRO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:14:58 -0400
Date: Tue, 24 Jul 2007 18:14:55 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
Message-ID: <20070724171455.GT21668@ftp.linux.org.uk>
References: <20070724153916.GS21668@ftp.linux.org.uk> <46A62F35.2000501@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A62F35.2000501@goop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 09:56:21AM -0700, Jeremy Fitzhardinge wrote:
> Al Viro wrote:
> > 	AFAICS, the patch below should do it for i386; instead of
> > using a dummy loop to tell gcc that this sucker never returns,
> > we do
> > static void __always_inline __noreturn __BUG(const char *file, int line);
> > containing the actual asm we want to insert and define BUG() as
> > __BUG(__FILE__, __LINE__).  It looks safe, but I don't claim enough
> > experience with gcc __asm__ potential nastiness, so...
> >
> > Comments, objections?
> >   
> 
> Does it work?  When I wrote the BUG code I tried this, but gcc kept
> warning about "noreturn function returns".  I couldn't work out a way to
> convince gcc that the asm is the end of the line.

Works here...
 
> I'm actually in favour of dropping the loop and the noreturn stuff
> altogether.  It means that gcc thinks everything is live at the time of
> the BUG, and the debugging info at the point of the ud2a is more useful.

It also means that gcc doesn't eliminate a bunch of codepaths.  It means
even more cretinous warnings about something being used uninitialized,
etc.
