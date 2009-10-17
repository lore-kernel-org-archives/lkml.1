Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbZJQXmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbZJQXmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 19:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZJQXmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 19:42:53 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:45342 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbZJQXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 19:42:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qhmXAPYnaQU2pMqGsB+JsDP7N9TqB71O0DTtCnUBB2zYbESPQinLNWOcdaMEggB1Om
         ZltXFDue4rYfbWKmaDL49hUrv/K7iKjQbsipzJ/QD4IpMimm1sACGUdB0PpxiFTwjqDU
         jtHbXeSpmh36+BWFTJGgGlUKgi/Xw/e08UGRc=
Date: Sun, 18 Oct 2009 01:42:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: hw-breakpoints: Actually flush thread
	breakpoints in flush_thread().
Message-ID: <20091017234250.GC10344@nowhere>
References: <20091005102306.GA7889@linux-sh.org> <20091005104955.GA14852@in.ibm.com> <20091009034003.GA7747@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009034003.GA7747@linux-sh.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 12:40:04PM +0900, Paul Mundt wrote:
> On Mon, Oct 05, 2009 at 04:19:55PM +0530, K.Prasad wrote:
> > On Mon, Oct 05, 2009 at 07:23:06PM +0900, Paul Mundt wrote:
> > > [ I noticed this whilst hacking up SH support, applies to the current
> > >   tracing/hw-breakpoints topic branch. ]
> > > 
> > > flush_thread() tries to do a TIF_DEBUG check before calling in to
> > > flush_thread_hw_breakpoint() (which subsequently clears the thread flag),
> > > but for some reason, the x86 code is manually clearing TIF_DEBUG
> > > immediately before the test, so this path will never be taken.
> > > 
> > > This kills off the erroneous clear_tsk_thread_flag() and lets
> > > flush_thread_hw_breakpoint() actually get invoked.
> > > 
> > 
> > Yes, this is wrong and we missed it. Thanks for fixing!
> > 
> > > Presumably folks were getting lucky with testing and the
> > > free_thread_info() -> free_thread_xstate() path was taking care of the
> > > flush there.
> > > 
> > > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> > 
> > Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > 
> > 
> Ingo, are you planning on picking this up? Or is there a hw-breakpoints
> tree somewhere outside of -tip that I'm unaware of?


I'm picking it.
Thanks.

