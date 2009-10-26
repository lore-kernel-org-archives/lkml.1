Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbZJZJrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbZJZJrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 05:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbZJZJrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 05:47:31 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43005 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbZJZJra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 05:47:30 -0400
Date: Mon, 26 Oct 2009 18:47:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Kill off -Wcast-align
Message-ID: <20091026094729.GB13517@linux-sh.org>
References: <20091026054000.GA13517@linux-sh.org> <20091026062520.GA29580@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091026062520.GA29580@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 07:25:20AM +0100, Ingo Molnar wrote:
> 
> * Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > The present use of -Wcast-align causes the build to blow up on SH due to
> > generating a "cast increases required alignment of target type" error on
> > each invocation of list_for_each_entry().
> > 
> > It seems that this was previously reported and killed off in the ia64
> > support patch, but nothing seems to have happened with that. Presumably
> > the same problem still remains there, too.
> > 
> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> Is this a GCC bug producing false positive warnings? The GCC manpage 
> says:
> 
>        -Wcast-align
>            Warn whenever a pointer is cast such that the required alignment of the
>            target is increased.  For example, warn if a "char *" is cast to an
>            "int *" on machines where integers can only be accessed at two- or
>            four-byte boundaries.
> 
> Which looks moderately useful - if it works.
> 
Well, both ia64 and sh have hit this in the current compilers, and it
doesn't seem to pose any code generation issues. In the areas where it is
generated it seems to relate to 64-bit data types in the data structures,
which in itself doesn't seem inherently problematic.

I'll submit a bug report to the GCC folks, but for the time being given
that multiple architectures are hitting this and it doesn't seem to be
causing any issues, it would be better to have this flag dropped.
