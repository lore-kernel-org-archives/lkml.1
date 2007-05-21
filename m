Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbXEUByj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbXEUByj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 21:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbXEUByb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 21:54:31 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4342 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbXEUByb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 21:54:31 -0400
Date: Mon, 21 May 2007 03:54:00 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Elimar Riesebieter <riesebie@lxtec.de>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2 built on ppc (2)
In-Reply-To: <20070520143752.2f6be87a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705210344130.1817@scrub.home>
References: <20070520110815.GD3253@aragorn.home.lxtec.de>
 <20070520143752.2f6be87a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 20 May 2007, Andrew Morton wrote:

> On Sun, 20 May 2007 13:08:15 +0200 Elimar Riesebieter <riesebie@lxtec.de> wrote:
> 
> > FYI, building 2.6.22-rc2 with
> > gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
> > on my powerbook (PPC) gives:
> > 
> > ...
> > kernel/time/ntp.c: In function 'do_adjtimex':
> > kernel/time/ntp.c:307: warning: comparison of distinct pointer types lacks a cast
> > kernel/time/ntp.c:310: warning: comparison of distinct pointer types lacks a cast
> 
> hm, do_div() is defined as operating on a u64, but ntp is passing it an s64
> and the asm-generic implementation of do_div() is warning about that.
> 
> Fixing that would be simple but a bit ugly.

The correct fix would be to clean up that API and provide a signed 
do_div(), so ntp doesn't have to work around for the lack of it.
It's on my todo list for ages, but I haven't gotten to it yet.

bye, Roman
