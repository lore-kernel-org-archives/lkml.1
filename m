Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYJXNRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYJXNRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYJXNRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:17:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYJXNRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:17:39 -0400
Date: Fri, 24 Oct 2008 09:17:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Rakib Mullick <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: use a real variable for ftrace_nop in x86
In-Reply-To: <alpine.DEB.1.10.0810240910020.3882@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0810240916350.3882@gandalf.stny.rr.com>
References: <b9df5fa10810122250j1dd9c0eaq8c708c7b8e10a249@mail.gmail.com> <20081020162756.GA31201@elte.hu> <20081022070312.GA24749@elte.hu> <b9df5fa10810240409u311bb337x1ff9815431088685@mail.gmail.com> <20081024115005.GA5214@elte.hu>
 <alpine.DEB.1.10.0810240910020.3882@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Oct 2008, Steven Rostedt wrote:

> 
> The dynamic ftrace determines which nop is safe to use at start up.
> When it finds a safe nop for patching, it sets a pointer called ftrace_nop
> to point to the code. All call sites are then patched to this nop.
> 
> Later, when tracing is turned on, this ftrace_nop variable is again used
> to compare the location to make sure it is a nop before we update it to
> a mcount call. If this fails just once, a warning is outputed and ftrace
> is disabled.
> 
> Rakib Mullick noted that the code that sets up the nop is a .init section
> where as the nop itself is in the .text section. This is needed because
> the nop is used later on after boot up. The problem is that the test of the
> nop jumps back to the setup code and causes a "section mismatch" warning.
> 
> Rabik first recommended to convert the nop to .init.text, but as stated
> above, this would fail since that text is used later.
> 
> The real solution is to extend Rabik's patch, and to make the ftrace_nop
> into an array, and just save the code from the assembly to this array.

Rereading what I sent, I see I misspelled Rakib's name twice.

Ingo, could you fix the changelog here before commiting it.

Thanks,

-- Steve

