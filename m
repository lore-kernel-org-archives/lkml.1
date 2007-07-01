Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbXGABsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbXGABsg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 21:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbXGABsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 21:48:25 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3179 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbXGABsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 21:48:25 -0400
Date: Sun, 1 Jul 2007 03:48:41 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
In-Reply-To: <20070629135847.70f1113b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707010120520.1817@scrub.home>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706291613040.1818@scrub.home> <20070629135847.70f1113b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 29 Jun 2007, Andrew Morton wrote:

> > Reset generates values only if Kconfig and .config agree.
> 
> unclear.  Could you please explain further what this change does?

Normally generated values (Kconfig entries without a prompt) are cleared 
as they are regenerated anyway and so they appear as new should they 
become visible and defaults work as expected (once a value is set defaults 
aren't used anymore).
The detection whether a value is generated or not is only based on its 
visibility status, which can quickly change for a lot of symbols by just 
removing a single line from .config or adding a dependency to Kconfig as 
you noticed.
The patch now suppresses this logic when .config and Kconfig aren't in 
sync and .config needs to be updated, so that you can remove now a random 
value from .config and oldconfig won't reask for many other values.

bye, Roman
