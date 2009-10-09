Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbZJIDlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbZJIDlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZJIDlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:41:36 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57340 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080AbZJIDlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:41:36 -0400
Date: Fri, 9 Oct 2009 12:40:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] x86: hw-breakpoints: Actually flush thread breakpoints in flush_thread().
Message-ID: <20091009034003.GA7747@linux-sh.org>
References: <20091005102306.GA7889@linux-sh.org> <20091005104955.GA14852@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091005104955.GA14852@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 04:19:55PM +0530, K.Prasad wrote:
> On Mon, Oct 05, 2009 at 07:23:06PM +0900, Paul Mundt wrote:
> > [ I noticed this whilst hacking up SH support, applies to the current
> >   tracing/hw-breakpoints topic branch. ]
> > 
> > flush_thread() tries to do a TIF_DEBUG check before calling in to
> > flush_thread_hw_breakpoint() (which subsequently clears the thread flag),
> > but for some reason, the x86 code is manually clearing TIF_DEBUG
> > immediately before the test, so this path will never be taken.
> > 
> > This kills off the erroneous clear_tsk_thread_flag() and lets
> > flush_thread_hw_breakpoint() actually get invoked.
> > 
> 
> Yes, this is wrong and we missed it. Thanks for fixing!
> 
> > Presumably folks were getting lucky with testing and the
> > free_thread_info() -> free_thread_xstate() path was taking care of the
> > flush there.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>
> 
> 
Ingo, are you planning on picking this up? Or is there a hw-breakpoints
tree somewhere outside of -tip that I'm unaware of?
