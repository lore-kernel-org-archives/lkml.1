Return-Path: <linux-kernel-owner+w=401wt.eu-S932381AbXBOV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbXBOV5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932833AbXBOV5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:57:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36011 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbXBOV5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:57:19 -0500
Date: Thu, 15 Feb 2007 13:53:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Optimize generic get_unaligned / put_unaligned
 implementations.
Message-Id: <20070215135358.020781dd.akpm@linux-foundation.org>
In-Reply-To: <20070215143441.GA18155@linux-mips.org>
References: <20050830104056.GA4710@linux-mips.org>
	<20060306.203218.69025300.nemoto@toshiba-tops.co.jp>
	<20060306170552.0aab29c5.akpm@osdl.org>
	<20070214214226.GA17899@linux-mips.org>
	<20070214203903.8d013170.akpm@linux-foundation.org>
	<20070215143441.GA18155@linux-mips.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 14:34:41 +0000
Ralf Baechle <ralf@linux-mips.org> wrote:

> On Wed, Feb 14, 2007 at 08:39:03PM -0800, Andrew Morton wrote:
> 
> > Can someone please tell us how this magic works?  (And it does appear to
> > work).
> > 
> > It seems to assuming that the compiler will assume that members of packed
> > structures can have arbitrary alignment, even if that alignment is obvious.
> > 
> > Which makes sense, but I'd like to see chapter-and-verse from the spec or
> > from the gcc docs so we can rely upon it working on all architectures and
> > compilers from now until ever more.
> > 
> > IOW: your changlogging sucks ;)
> 
> It was my entry for the next edition of the C Puzzle Book ;-)
> 
> The whole union thing was only needed to get rid of a warning but Marcel's
> solution does the same thing by attaching the packed keyword to the entire
> structure instead, so this patch is now using his macros but using __packed
> instead.

How do we know this trick will work as-designed across all versions of gcc
and icc (at least) and for all architectures and for all sets of compiler
options?

Basically, it has to be guaranteed by a C standard.  Is it?
