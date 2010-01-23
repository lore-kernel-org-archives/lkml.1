Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572Ab0AWBrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab0AWBrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140Ab0AWBro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:47:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753934Ab0AWBrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:47:43 -0500
Date: Fri, 22 Jan 2010 17:47:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: =?ISO-8859-15?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] string: simplify stricmp()
In-Reply-To: <20100122162740.11410ac4.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1001221743521.13231@localhost.localdomain>
References: <cover.1263675077.git.andre.goddard@gmail.com> <16ee7c5e218e89f22a28247e4bd3877355f5ae5c.1263675077.git.andre.goddard@gmail.com> <20100122162740.11410ac4.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jan 2010, Andrew Morton wrote:
> 
> hm, that function seems a little broken.
> 
> If it reaches the end of s1 or s2 it will return (c1 - c2).  If however
> it detects a difference due to other than end-of-string, it returns
> (tolower(c1) - tolower(c2)).
> 
> IOW, perhaps it should be performing tolower() in the
> I-reached-end-of-string case.

No, it doesn't matter. It's like strcmp - it returns "positive, negative 
or zero" depending on whether the string compared bigger than, smaller 
than or equal.

So "(int)c1 - (int)c2" is just a way to do that. And if the string ends 
and c1 or c2 is NUL, there's no point in doing the "tolower()", because it 
doesn't matter what the other character is: the sign is all that matters 
(or, if they are equally long, and both c1 and c2 are zero, then 0).

> I wonder what strnicmp() is _supposed_ to return..

Same as strncmp.

We could make it always return -1/0/+1 (many libraries do that - then the 
return value is guaranteed to also fit in a 'char', not just an 'int'), 
but it really shouldn't matter for any correct caller.

		Linus
