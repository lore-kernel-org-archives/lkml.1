Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0CDKSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 05:18:53 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48832 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753442Ab0CDKSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 05:18:49 -0500
Subject: Re: kmemleak issue on ARM target
From: Catalin Marinas <catalin.marinas@arm.com>
To: naveen yadav <yad.naveen@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <9bde694e1003040113k3b573957h1b831c8d25205d22@mail.gmail.com>
References: <9bde694e1003040113k3b573957h1b831c8d25205d22@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Thu, 04 Mar 2010 10:18:44 +0000
Message-ID: <1267697924.6526.5.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2010 10:18:44.0729 (UTC) FILETIME=[121A9690:01CABB84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 09:13 +0000, naveen yadav wrote:
> W am facing one issue on ARM target, we have 512 MB ram on our target,
> we port your patch of
> kmemleak(http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg11830.html)
> 
> We are facing problem in DEBUG_KMEMLEAK_EARLY_LOG_SIZE we cannot
> increase its size above 1000 because of our kernel Image size for
> embedded board
> has some limit that if it increase we cannot execute it. so is there
> any implementaion possible using vmalloc and not statically allocating
> the log of array or else any suggestion.

Not really. This buffer needs to be static because it is used before
kmemleak is fully initialised. It's also tracking bootmem allocations.

But this size should not increase the Image file size as it should go in
the BSS section.

An additional question - why do you need to increase this size? I found
400 to be enough usually. Do you get any errors?

Since you backported kmemleak, please make sure that you check the
latest code in mm/kmemleak.c as there are some bug-fixes.


-- 
Catalin

