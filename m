Return-Path: <linux-kernel-owner+w=401wt.eu-S1764281AbYD0Uj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764281AbYD0Uj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYD0UjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:39:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbYD0UjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:39:18 -0400
Date: Sun, 27 Apr 2008 13:38:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
In-Reply-To: <1209328161.14173.77.camel@brick>
Message-ID: <alpine.LFD.1.10.0804271335330.3119@woody.linux-foundation.org>
References: <1209327591.14173.74.camel@brick>  <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org> <1209328161.14173.77.camel@brick>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 27 Apr 2008, Harvey Harrison wrote:
>
> Oh, I didn't realize, I only did this because sparse started spewing out
> lots of:
> include/linux/bitops.h:166:32: warning: shift too big (65536) for type unsigned long

Well, that's really just a sparse bug/misfeature that didn't matter 
before.

It happens because the warning is done as part of constant expression 
evaluation, but then the expression isn't actually *used*, so when we 
optimize it away - at a later date - it's too late to undo the warning.

I don't rightly know how to fix it. We do want to do the constant 
evaluation early (since all the optimizations that may then make it a 
non-issue depends on constants being constants!), but in order to not 
output the warning we'd have to turn the constant into a "constant with 
warning 'xyz' if used".

Which we have no support for in sparse yet.

		Linus
