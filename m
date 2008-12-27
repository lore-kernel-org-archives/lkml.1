Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbYL0TYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbYL0TYE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 14:24:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYL0TXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 14:23:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53460 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbYL0TXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 14:23:52 -0500
Message-ID: <495680A7.2010900@zytor.com>
Date: Sat, 27 Dec 2008 11:23:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227191223.GA10592@uranus.ravnborg.org> <49567EB5.5030409@zytor.com> <200812271421.10087.vapier@gentoo.org>
In-Reply-To: <200812271421.10087.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> 
> {su}{8,16,32,64} doesnt matter too much to me vs {u,}int_t{8,16,32,64}_t.  as 
> long as people stop using __{su}{8,16,32,64}.  using the latter though does 
> mean headers will more likely be "just usable" w/out needing linux/types.h 
> include.  but then people would be forced to include stdint.h or similar 
> before a linux header ... and that sucks.
> 

That is a total non-starter.  This would mean that the C library itself
cannot use these headers without exporting additional symbols into the
namespace, *WHICH IT IS NOT ALLOWED TO DO*.

> unless of course we start adding appropriate C library includes for 
> !__KERNEL__ ... i'd love that personally
> 
>> and bool into the appropriate __{su}{8,16,32,64}
>> types and _Bool.
> 
> i dont get your bool comment.  the "bool" type is already a standard type.  
> there is no conversion needed.

Only if <stdbool.h> is included.  Again, see previous statement.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

