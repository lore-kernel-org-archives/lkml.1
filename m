Return-Path: <linux-kernel-owner+w=401wt.eu-S1759111AbXERDjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759111AbXERDjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 23:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756076AbXERDjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 23:39:00 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2634 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbXERDi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 23:38:59 -0400
Date: Fri, 18 May 2007 05:38:06 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Al Viro <viro@ftp.linux.org.uk>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       kbuild-devel@lists.sourceforge.net
Subject: Re: [RFC] select and dependencies in Kconfig
In-Reply-To: <20070516033335.GH4095@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0705170406400.1817@scrub.home>
References: <E1Ho2om-0003TN-Ah@ZenIV.linux.org.uk> <20070516033335.GH4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 16 May 2007, Al Viro wrote:

> On Tue, May 15, 2007 at 08:36:20PM +0100, Al Viro wrote:
> > 
> > stuff that does select USB should depend on USB_ARCH_HAS_HCD, or we'll
> > end up with unbuildable configs.
> 
> BTW, this kind of situation happens often enough, so how about doing
> the following: teach kconfig that if FOO selects BAR and BAR depends
> on <expr>, we should act as if FOO had explicit depends on <expr>.

select was really intended to override the dependencies (Russell gave a 
few examples), the other usage is what is abusing select (I can 
understand why people are doing it, but it still is).
So I'd really like to get the focus away from select and rather see it as 
a new syntax.

One problem with your idea is that a symbol itself has no normal 
dependencies. A symbol has properties and these have the dependencies, so 
it's not that easy. What could be used is the visibility value of a symbol 
of a symbol, but that can't be used in expressions yet.

The problem is now being able to select visible and nonvisible symbols. 
One way is to introduce a new syntax for the behaviour you suggest or we 
change the current select syntax and mark nonvisible symbols as being 
selectable. Considering the current problems I sort of like the latter.

bye, Roman
