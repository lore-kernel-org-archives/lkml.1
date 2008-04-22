Return-Path: <linux-kernel-owner+w=401wt.eu-S1762800AbYDVKei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800AbYDVKei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 06:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759863AbYDVKea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 06:34:30 -0400
Received: from hu-out-0506.google.com ([72.14.214.237]:33291 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833AbYDVKe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 06:34:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pu1c8HC3vw6Gxvp6jsuNNHu9zVi3rmhYunEWdSIQuVCOmFfEp9o4fEZ8/QHQhh68DO38HH5EhU7wQWQPpie0QUQ8Ul3NmJcE6ige3W+d806IIsRBjvuOCAAJe0dKQPs+GXW8/eNxuxhfjJTWnJhRd5ieceoACvlHQU+qmsvJqDI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] xfs: do not pass unused params to xfs_flush_pages
Date: Tue, 22 Apr 2008 12:33:50 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, David Chinner <dgc@sgi.com>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804221057.33324.vda.linux@googlemail.com> <20080422095621.GT2255@devserv.devel.redhat.com>
In-Reply-To: <20080422095621.GT2255@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221233.50360.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 11:56, Jakub Jelinek wrote:
> On Tue, Apr 22, 2008 at 10:57:33AM +0200, Denys Vlasenko wrote:
> > You do not see reduced stack usage in "make checkstack",
> > because "make checkstack" shows only stack usage caused by
> > local variables (it analyses sub %esp,NN instructions which
> > make room for them). Parameters also take up stack, but
> > they are pushed on stack with push instruction,
> > and so are invisible in "make checkstack" output.
> 
> That on i?86 actually depends on whether -maccumulate-outgoing-args
> is on or off (the default is off for -Os and most pre-i686 tunings,
> and on for i686 and most post-i686 tunings when not -Os).

I trust you know it better than I.

I removed a few parameters of non-static, non-inline function.
Since at call site gcc has no way of knowing that these parameters
will not be used by callee, and the function is not regparm
(explicitly or implicitly by being static), I am fairly sure
gcc is putting these parameters on stack.

"make checkstack" doesn't see any difference. It can only
mean that "make checkstack" does not account for stack space
taken by parameters, not that there is no difference
in stack usage after this change. That is simply not possible IMO.
--
vda
