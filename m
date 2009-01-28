Return-Path: <linux-kernel-owner+w=401wt.eu-S1753349AbZA1UD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbZA1UD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZA1UDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:03:19 -0500
Received: from mail-gx0-f21.google.com ([209.85.217.21]:51186 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZA1UDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:03:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ABPaN5eoKBC15ME23p3wt8xCX/8ey18J/rxgskeqxzFgTRjRLwsi5wUzHIvreNrUCz
         vF010PK7sVeboyImlGwUmpnZPA28o2Jkso4M6BXf7Bzc291RkfOJvoujIXSDuWmJXYtR
         r0AjHtFjg6+9VKjp6oVdOILhn9XIJoVtrNT0U=
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
	 <1233106614.3256.6.camel@localhost.localdomain>
	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>
	 <1233170532.6717.49.camel@brick>
	 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 12:03:14 -0800
Message-Id: <1233172994.6717.56.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 11:44 -0800, Linus Torvalds wrote:
> 
> On Wed, 28 Jan 2009, Harvey Harrison wrote:
> > On Wed, 2009-01-28 at 09:48 -0800, H. Peter Anvin wrote:
> > > 
> > > In general, no.  The byteswap API is a legacy exception.
> > 
> > But now that swab.h has been separated out, we could just stop exporting the
> > asm/swab.h bits while still providing a generic C-based implementation to
> > userspace.
> 
> Well, the _reason_ the byteswap stuff has been interesting to user space 
> is that the kernel did it better than the alternatives. Rather than having 
> purely "work with big-endian data" (the networking htonl etc functions), 
> the kernel had good and fairly optimized handling of various different 
> forms of byte order handling.
> 
> Which is why people wanted to use it in the first place - and which is why 
> then doing just the generic C-based thing doesn't really fix the issue. 
> Things may compile, but they kind of lost the point.

There was at least some discussion on the gcc-list in November about recognizing
the byteswap idiom and inserting optimized instructions if available...so hopefully
in the future this just fixes itself.

For now, the problem is with arches like X86 that need to test the availability of
an instruction.  So the arch versions could be unconditionally offered on X86_64
and the lowest-common denominator (no BSWAP) on X86-32.  If we still want the
optimized (BSWAP) versions on X86-32 the tests will have to use the compiler arch flags
as opposed to CONFIG_BSWAP....which is probably not worth the trouble.

Harvey

