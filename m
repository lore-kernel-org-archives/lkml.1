Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbZAaUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbZAaUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 15:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbZAaUZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 15:25:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbZAaUZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 15:25:14 -0500
Message-ID: <4984B384.3050509@zytor.com>
Date: Sat, 31 Jan 2009 12:24:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
References: <20090127222825.GA27097@elte.hu>  <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>  <1233106614.3256.6.camel@localhost.localdomain>  <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>  <1233170532.6717.49.camel@brick>  <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>  <1233172994.6717.56.camel@brick>  <4980CD51.70601@zytor.com>  <1233179884.6717.59.camel@brick>  <4980D913.3000505@zytor.com> <1233182314.6717.66.camel@brick> <alpine.LFD.1.10.0901311842140.16187@ftp.linux-mips.org>
In-Reply-To: <alpine.LFD.1.10.0901311842140.16187@ftp.linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Wed, 28 Jan 2009, Harvey Harrison wrote:
> 
>> Well, that's unfortunate, how about we just export the BSWAP version
>> unconditionally and hope pure i386 just goes away someday?
> 
>  Or just emulate it alongside CMPXCHG and XADD? ;)

That would work unless someone actually cares about 386 or 486 in the
embedded space.  I think at least 486EX is still used as an embedded
platform.

The kernel can obviously provide this service (although it slows down
the #UD handler), but anyone who actually cares about these chips would
not really want them.

At some point, we may want to ask ourselves how long keeping 386 support
(with it's broken WP handling) alive.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

