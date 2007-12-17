Return-Path: <linux-kernel-owner+w=401wt.eu-S1764949AbXLQWHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764949AbXLQWHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765465AbXLQWG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:06:57 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:29554 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935647AbXLQWGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:06:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WA6g9e3XW+diO7FSNNdth7jmpd1rXqqx0kPL4Ci+MLylfsDjCyoWjkFr+IsbsdEifQom4J8cXZMIn5gQHQxIx56G+WZklTZqcaGKlE2Q2q4D+Zu/vHsdJHPFZjzvMlPOAg1hdIFaj7UkuTlVIDMmFFd5Gmp+pZDr0T472QZZ2dk=
Subject: Re: FInal kprobes rollup patches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>, srinivasa@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
In-Reply-To: <4766EFA8.9070907@redhat.com>
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu>
	 <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>
	 <20071217142235.GA21379@linux.vnet.ibm.com>
	 <1197919234.23402.5.camel@brick>  <4766E9FC.7050101@redhat.com>
	 <1197927385.23402.41.camel@brick>  <4766EFA8.9070907@redhat.com>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 14:00:23 -0800
Message-Id: <1197928823.23402.108.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 16:52 -0500, Masami Hiramatsu wrote:
> Hi Harvey,
> Before porting, could you tell me what differences are important
> to you? We can discuss about it.
> 
> > I just sent out a series of 4 patches equivalent to your patches 1-4/6
> > but based on my already unified kprobes.c/h, You may want to check your
> > handling of restored registers in trampoline_probe_handler which I found
> > when rebasing yours on top of my cleanups.  Not sure if this is
> > important, but it was a difference I found.
> > 
> > X86_32:
> > regs->cs = __KERNEL_CS | get_kernel_rpl();
> > 
> > yours:
> > regs->cs = __KERNEL_CS;
> 
> Because of kretprobe's compatibility, on x86-32 cs should be set rpl().
> But get_kernel_rpl() does not exist on x86-64.
> 

I've already ported it and sent it to you.  It's not really important to
me I just think my fine-grained patches may be of some use to see where
the differences between X86_32/64 ended up being.  Your patches end up
being just about entirely removal of ifdefs when rebased onto my
patches, so it's at least a good secondary check of your patches even
if mine don't go in.  Your patches end up being much smaller against
my version too.

I like my version slightly better because the remaining ifdefs (wrmsr,
etc) and others could be done in a few more small patches that are more
easily reviewable than your large final unification patch.

But, you know the code better than I....

Harvey

