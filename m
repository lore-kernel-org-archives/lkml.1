Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYDZQRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYDZQRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 12:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbYDZQRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 12:17:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55899 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYDZQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 12:17:30 -0400
Date: Sat, 26 Apr 2008 10:17:14 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Adrian Bunk <bunk@kernel.org>, linux-kbuild@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headerdep: a tool for detecting inclusion cycles in header file
Message-ID: <20080426161714.GR14990@parisc-linux.org>
References: <20080426134554.GA20727@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426134554.GA20727@damson.getinternet.no>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 03:45:54PM +0200, Vegard Nossum wrote:
> Maybe something like this could be useful for cleaning up headers (and
> maintaining that cleanliness once it has been achieved). What do you think?
> 
> Subject: [PATCH] headerdep: a tool for detecting inclusion cycles in header files

Do we actually have inclusion cycles in header files?  I remember gcc
warning about them when we were working on the parisc port (because we
needed includes that differed from x86).  Has the new build system got
rid of these warnings?

I think a more useful tool would be one which mapped something like
'use of down()' to 'needs to include <linux/semaphore.h>'.  It needs
to be at least somewhat done by hand because there are rules such
as 'include linux/spinlock.h to get spinlock_t' (which is actually
defined in linux/spinlock_types.h), but you want people to include
<linux/completion.h> directly rather than rely on it being pulled in
through linux/sched.h, for example.

It's further complicated by multi-file drivers, such as qla2xxx.  Each
file includes qla_def.h which includes a lot of the necessary header
files for them ... but then each file will include a few more header
files that it needs.

So some implicit includes are _good_ and other implicit includes are
_bad_ (as they hurt when trying to rationalise the header files).
Anyone who likes complexity and fuzzy logic like this want to take a
stab at writing such a tool?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
