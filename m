Return-Path: <linux-kernel-owner+w=401wt.eu-S1759018AbYGRUdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018AbYGRUdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 16:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGRUdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 16:33:38 -0400
Received: from jade.aracnet.com ([216.99.193.136]:46621 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbYGRUdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 16:33:37 -0400
Message-ID: <4880FDA1.9070307@BitWagon.com>
Date: Fri, 18 Jul 2008 13:31:29 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Mozilla Thunderbird 1.0.8-1.1.fc4 (X11/20060501)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Nathan Lynch <ntl@pobox.com>
CC: Andrew Morton <akpm@linux-foundation.org>, benh@kernel.crashing.org,
       torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, roland@redhat.com
Subject: Re: [PATCH v3] elf loader support for auxvec base platform string
References: <1216166331-14810-1-git-send-email-ntl@pobox.com> <1216166331-14810-2-git-send-email-ntl@pobox.com> <1216276539.7740.309.camel@pasglop> <20080717000951.5f8cab37.akpm@linux-foundation.org> <20080717221932.GL9594@localdomain> <20080717154218.8981035c.akpm@linux-foundation.org> <487FD74C.4080603@BitWagon.com> <20080718182850.GO9594@localdomain>
In-Reply-To: <20080718182850.GO9594@localdomain>
X-Enigmail-Version: 0.92.0.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch wrote:

> +#define AT_EXECFN  31	/* filename of program */
> 
> How did you arrive at 31 for the value of AT_EXECFN?  I haven't been
> able to find out how AT_* values are "allocated", or what the reason
> is for the gap between AT_SECURE and AT_SYSINFO.

The numbers are chosen by experience, taste, and fiat.
Hopefully new choices do not conflict with existing ones,
but there is no formal "issuing authority."
In history the auxiliary vector has been not well standardized
and many times has been hidden from view of applications, although some
SysV-based systems have made it visible as a fourth argument to main().
Linux has /proc/pid/auxv, although the implementation suffers
from being exposed to overwriting by the user.  From long experience
at virtualization in user mode, I favor better access, more use,
and better understanding of what the auxiliary vector provides.

AT_SYSINFO at 32 was chosen to avoid conflicts with [0,31]
partly on the theory that the first 32 might be considered
to be reserved for use across all UNIX-like systems,
while AT_SYSINFO definitely was Linux-specific.
I chose AT_EXECFN at 31 because I considered the concept
to be applicable to any system having execve(), even if AT_EXECFN
is not universally implemented.  I had not seen any new tags
below 32 in a long time.  The concept of AT_EXECFN allows
a nice interface for a virtualizer. The somewhat-related
AT_EXECFD already exists below 32.

Elsewhere, I've staked out use of a new AT_WINE_PRELOAD_INFO
at 30.  Avoid that one, please. :-)

-- 
John Reiser, jreiser@BitWagon.com
