Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbXETVkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbXETVkl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 17:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbXETVke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 17:40:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756639AbXETVkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 17:40:33 -0400
Date: Sun, 20 May 2007 14:37:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Elimar Riesebieter <riesebie@lxtec.de>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: 2.6.22-rc2 built on ppc (2)
Message-Id: <20070520143752.2f6be87a.akpm@linux-foundation.org>
In-Reply-To: <20070520110815.GD3253@aragorn.home.lxtec.de>
References: <20070520110815.GD3253@aragorn.home.lxtec.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007 13:08:15 +0200 Elimar Riesebieter <riesebie@lxtec.de> wrote:

> FYI, building 2.6.22-rc2 with
> gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
> on my powerbook (PPC) gives:
> 
> ...
> kernel/time/ntp.c: In function 'do_adjtimex':
> kernel/time/ntp.c:307: warning: comparison of distinct pointer types lacks a cast
> kernel/time/ntp.c:310: warning: comparison of distinct pointer types lacks a cast

hm, do_div() is defined as operating on a u64, but ntp is passing it an s64
and the asm-generic implementation of do_div() is warning about that.

Fixing that would be simple but a bit ugly.

The code around there needs to be taught about min_t and max_t, too..
