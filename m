Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZCHL27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZCHL27 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 07:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZCHL2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 07:28:48 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:63608 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZCHL2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 07:28:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p8ucqdgAQQByAV+hOyum9kJF/KEd7SgkMCCexxMbuPBJL4wFDfuTYjXFm3WTwndOTZ
         QSvapv+vgZQy1TuET2+8Bt8X6nXi+F4saiwUgOsM/CdsHxGvD+P/oz+3OnQyorB03Ru9
         e2/nvn2rU/ufy9ZtDq3ZMbRWmF78tyEuhk2uc=
Date: Sun, 8 Mar 2009 12:28:41 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 0/2] Syscalls tracing
Message-ID: <20090308112840.GC5000@nowhere>
References: <1236401580-5758-1-git-send-email-fweisbec@gmail.com> <1236428118.6376.239.camel@laptop> <20090307160246.GB6075@nowhere> <20090308112440.GB5000@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090308112440.GB5000@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 08, 2009 at 12:24:41PM +0100, Frederic Weisbecker wrote:
> On Sat, Mar 07, 2009 at 05:02:47PM +0100, Frederic Weisbecker wrote:
> > On Sat, Mar 07, 2009 at 01:15:18PM +0100, Peter Zijlstra wrote:
> > > On Sat, 2009-03-07 at 05:52 +0100, Frederic Weisbecker wrote:
> > > > Here is a first attempt, quick one-shot, to provide a syscall tracing
> > > > infrastructure on ftrace.
> > > > 
> > > > The RFC prefix is here to reflect its ugliness on various parts.
> > > > The compromise between tracing reliabilty and speed is hard to balance.
> > > > For example I guess the basic and horrid string mask should be dropped in favour
> > > > of something else, which takes care of the volatile strings from the userspace.
> > > > 
> > > > But I hope a lot of ideas to make it better will come along this discussion.
> > > 
> > > Can't you abuse the SYSCALL_DEFINE macros? This current approach looks
> > > like it will replicate the syscall table.
> > > 
> > 
> > 
> > Ah, I did not even think about it.
> > I will be able to get the number of parameters. Sounds good. But I will
> > still need a way to store their format somewhere.
> >
> 
> Ok, we can iterate through sections datas for each one and then generate the format string
> depending of the types of the parameters. We can even to it once at boot time.
> The last thing is the need to match the exact syscall entry from this section when we enter
> a syscall. Don't know yet how I will do that but I will think about it.
> 

Ah and the string mask is actually useful to determine if we one parameter is a string.
If so we can decide to save it on tracing time or not.

