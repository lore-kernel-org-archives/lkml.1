Return-Path: <linux-kernel-owner+w=401wt.eu-S1762378AbXG0STW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762378AbXG0STW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:19:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbXG0SS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:18:58 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:52499 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbXG0SS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:18:57 -0400
Message-ID: <46AA3680.4010508@gmail.com>
Date: Fri, 27 Jul 2007 20:16:32 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Daniel Hazelton <dhazelton@enter.net>
CC: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com> <20070727030040.0ea97ff7.akpm@linux-foundation.org> <1185531918.8799.17.camel@Homer.simpson.net> <200707271345.55187.dhazelton@enter.net>
In-Reply-To: <200707271345.55187.dhazelton@enter.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2007 07:45 PM, Daniel Hazelton wrote:

> Updatedb or another process that uses the FS heavily runs on a users
> 256MB P3-800 (when it is idle) and the VFS caches grow, causing memory
> pressure that causes other applications to be swapped to disk. In the
> morning the user has to wait for the system to swap those applications
> back in.
> 
> Questions about it:
> Q) Does swap-prefetch help with this? 
> A) [From all reports I've seen (*)] Yes, it does. 

No it does not. If updatedb filled memory to the point of causing swapping 
(which noone is reproducing anyway) it HAS FILLED MEMORY and swap-prefetch 
hasn't any memory to prefetch into -- updatedb itself doesn't use any 
significant memory.

Here's swap-prefetch's author saying the same:

http://lkml.org/lkml/2007/2/9/112

| It can't help the updatedb scenario. Updatedb leaves the ram full and
| swap prefetch wants to cost as little as possible so it will never
| move anything out of ram in preference for the pages it wants to swap
| back in.

Now please finally either understand this, or tell us how we're wrong.

Rene.

