Return-Path: <linux-kernel-owner+w=401wt.eu-S1757501AbXHRSzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501AbXHRSzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 14:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbXHRSza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 14:55:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:56179 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXHRSza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 14:55:30 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] x86-64: memset optimization
Date: Sat, 18 Aug 2007 20:55:11 +0200
User-Agent: KMail/1.9.6
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, jh@suse.cz
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net> <200708181146.24399.ak@suse.de> <20070818075602.34350b25@freepuppy.rosehill.hemminger.net>
In-Reply-To: <20070818075602.34350b25@freepuppy.rosehill.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708182055.11277.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The problem is that on x86-64 you are overriding memset() 

I don't.  You must be looking at old source

asm-x86_64/string.h 2.6.23rc3:

#define __HAVE_ARCH_MEMSET
void *memset(void *s, int c, size_t n);

I wanted to do the same on i386 too, but there were some minor obstacles.
The problem is that the out of line fallback i386 memset is currently
quite dumb and needs to be rewritten to expand the fill char on its
own like the x86-64 version. Probably best would be just to port
the x86-64 version. I just hadn't had time for that.

[Patches welcome, but if you do ask me for my old memset test harness]

-Andi
