Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYKGIC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYKGIC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 03:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751118AbYKGICu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 03:02:50 -0500
Received: from lazybastard.de ([212.112.238.170]:56636 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYKGICu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 03:02:50 -0500
Date: Fri, 7 Nov 2008 09:02:37 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Always include <linux/types.h>
Message-ID: <20081107080237.GB28847@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817069-5969-1-git-send-email-bharrosh@panasas.com> <20081104180347.GA9818@uranus.ravnborg.org> <20081105163941.GB6561@logfs.org> <20081105172312.GA10585@x200.localdomain> <20081105191628.GC6561@logfs.org> <20081105200216.GD6561@logfs.org> <20081105203212.GA11910@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081105203212.GA11910@x200.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 November 2008 23:32:12 +0300, Alexey Dobriyan wrote:
> 
> If you are working on improving compile times, it's better concentrate
> on removing unneeded includes. If just removing "extern"s from prototypes
> can reliably save several seconds, reducing headers can do wonders.

My goal was more to assume we want all headers to compile standalone and
see where that would lead.  Result for include/linux/ was some 500 added
lines, 170 of which were to add types.h or compiler.h.  Another 50-100
further includes were fairly well-spread across the spectrum.  The
remainder was declarations like
struct super_block;

Overall we have three evils to choose from.  Headers with unresolved
dependencies lead to random compile breakage after removing a header
from some .c file.  Even if the change was tested, it can still break
for some config/architecture combination month down the line.

Sprinkling more includes throughout the headers increase compile time.
And the common practice of declaring a structure instead of including
the header is a pita when working with ctags.  The last problem is
particularly annoying since I have no idea what problem this warning is
supposed to solve:
In file included from include/linux/coda_cache.c:1:
include/linux/coda_cache.h:18: warning: ‘struct super_block’ declared inside parameter list
include/linux/coda_cache.h:18: warning: its scope is only this definition or declaration, which is probably not what you want

Should we just teach gcc to shut up about that one?

Jörn

-- 
Anything that can go wrong, will.
-- Finagle's Law
