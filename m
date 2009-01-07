Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZAGFCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZAGFCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 00:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZAGFB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 00:01:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750786AbZAGFB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 00:01:56 -0500
Date: Tue, 6 Jan 2009 21:01:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: powerpc: introduce asm/swab.h
In-Reply-To: <1231303340.14860.61.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0901062056540.3057@localhost.localdomain>
References: <200901070400.n0740Ore002063@hera.kernel.org> <1231303340.14860.61.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Jan 2009, Benjamin Herrenschmidt wrote:
> 
> Was this tested ? I see no arch maintainer signed-off here, it appears
> to at least break ppc32, and contains hunks that paulus says were
> explicitely nacked (removing of our ld_* macros) etc...

It did no such thing. It just moved the file.

Use

	git show -M -B 156ca2bbf6503a02d7d6829886ce381d572de66e

to see how <asm/swab.h> is just the old <asm/byteorder.h> renamed, and 
with some stuff moved around. Eg it contains:

	-#define __BIG_ENDIAN
	-#include <linux/byteorder.h>

because now the <asm/byteorder.h> header file on powerpc will just do

	+#include <asm/swab.h>
	+#include <linux/byteorder/big_endian.h>

instead of doing that __BIG_ENDIAN define and conditionals that didn't 
work with user space.

So it really should be a no-op. And no, I'm not reverting it, because 
I guarantee that reverting it won't result in a working build - the broken 
<linux/byteorder.h> file no longer exists (and will not be re-instated).

So I'd suggest testing it, and if it really doesn't work, trying to figure 
out why. Because a revert won't be helping.

			Linus
