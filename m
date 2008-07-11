Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYGKMeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYGKMeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 08:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYGKMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 08:34:16 -0400
Received: from ozlabs.org ([203.10.76.45]:53897 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYGKMeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 08:34:15 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -next-20080709] fixup stop_machine use cpu mask vs ftrace
Date: Fri, 11 Jul 2008 22:34:00 +1000
User-Agent: KMail/1.9.9
Cc: Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@redhat.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200807081756.47140.rusty@rustcorp.com.au> <for-27-patch0-1@bga.com> <20080711074602.GB27849@elte.hu>
In-Reply-To: <20080711074602.GB27849@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807112234.00993.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008 17:46:03 Ingo Molnar wrote:
> * Milton Miller <miltonm@bga.com> wrote:
> > Hi Rusty, Ingo.
> >
> > Rusty's patch [PATCH 3/3] stop_machine: use cpu mask rather than magic
> > numbers didn't find kernel/trace/ftrace.c in -next, causing an
> > immediate almost NULL pointer dereference in ftrace_dynamic_init.
>
> Rusty - what's going on here? Please do not change APIs like that, which
> cause code to crash. Either do a compatible API change, or change it
> over in a way that causes clear build failures, not crashes.

To be fair, I did.  Unfortunately GCC only warns about passing an int to a 
pointer arg, and boom.

But compatible is even better.  Given the number of stop_machine_run users I 
thought it unlikely that a new one would be introduced during the change.  I 
was wrong, so I'll do it the Right Way.

Cheers,
Rusty.
