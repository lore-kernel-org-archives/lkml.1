Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZA1To5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZA1To5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 14:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZA1Tos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 14:44:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979AbZA1Tos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 14:44:48 -0500
Date: Wed, 28 Jan 2009 11:44:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
In-Reply-To: <1233170532.6717.49.camel@brick>
Message-ID: <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu>  <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>  <1233106614.3256.6.camel@localhost.localdomain>  <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org> <1233170532.6717.49.camel@brick>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Jan 2009, Harvey Harrison wrote:
> On Wed, 2009-01-28 at 09:48 -0800, H. Peter Anvin wrote:
> > 
> > In general, no.  The byteswap API is a legacy exception.
> 
> But now that swab.h has been separated out, we could just stop exporting the
> asm/swab.h bits while still providing a generic C-based implementation to
> userspace.

Well, the _reason_ the byteswap stuff has been interesting to user space 
is that the kernel did it better than the alternatives. Rather than having 
purely "work with big-endian data" (the networking htonl etc functions), 
the kernel had good and fairly optimized handling of various different 
forms of byte order handling.

Which is why people wanted to use it in the first place - and which is why 
then doing just the generic C-based thing doesn't really fix the issue. 
Things may compile, but they kind of lost the point.

		Linus
