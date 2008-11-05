Return-Path: <linux-kernel-owner+w=401wt.eu-S1757826AbYKEUEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826AbYKEUEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbYKEUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:02:28 -0500
Received: from lazybastard.de ([212.112.238.170]:56320 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758368AbYKEUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:02:27 -0500
Date: Wed, 5 Nov 2008 21:02:17 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Always include <linux/types.h>
Message-ID: <20081105200216.GD6561@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817069-5969-1-git-send-email-bharrosh@panasas.com> <20081104180347.GA9818@uranus.ravnborg.org> <20081105163941.GB6561@logfs.org> <20081105172312.GA10585@x200.localdomain> <20081105191628.GC6561@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081105191628.GC6561@logfs.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 November 2008 20:16:28 +0100, Jörn Engel wrote:
> 
> My hope was actually to speed up compilation.  If the average c file
> includes 10 headers, on types.h will get included by most of them,
> possibly multiple times.  Each run after the first still has to parse
> the whole file, just to drop everything between  #ifndef _LINUX_TYPES_H
> and #endif.
> 
> By passing types.h on the command line we can drop it from all headers
> and only have to parse it once.  Just the intermediate step of parsing
> types.h 11 times instead of 10 will slow things down.  By about .4% on
> my not very beefy notebook.
> 
> Before:
> real    4m33.241s
> user    3m58.524s
> sys     0m18.539s
> 
> After:
> real    4m29.707s
> user    3m59.674s
> sys     0m18.182s

And after removing all explicit #include <linux/types.h> from headers:
real    4m31.946s
user    3m59.521s
sys     0m18.752s

All this may be lost in the noise.  The build machine wasn't completely
idle and the variation in system time is rather random.  So it neither
helps nor hurts much.  Nor does it solve any real problem.

We might just as well drop it, I guess.

Jörn

-- 
The story so far:
In the beginning the Universe was created.  This has made a lot
of people very angry and been widely regarded as a bad move.
-- Douglas Adams
