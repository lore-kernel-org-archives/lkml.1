Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZEFOmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZEFOmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZEFOmh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:42:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45491 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbZEFOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:42:36 -0400
Date: Wed, 6 May 2009 16:47:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 0/2] oprofile: introduce module parameter oprofile.cpu_type
Message-ID: <20090506144720.GQ23223@one.firstfloor.org>
References: <1241613554-31539-1-git-send-email-robert.richter@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241613554-31539-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 02:39:12PM +0200, Robert Richter wrote:
> The current userland does not yet fully support all cpu types
> implemented in the kernel. With the module parameter oprofile.cpu_type
> a certain cpu type can be reported to the oprofile userland and thus
> makes the kernel usable with current distros.

On Intel systems forcing archperfmon is the only one that makes sense
nd only if the CPU supports arch perfmon(btw that's already in my patchkit
which you haven't commented on so far)

I don't thinking forcing core2 on a system like Nehalem with completely
different events is a good idea though. This just means if the user
selects anything unusual they will get junk data, which is just
a bad design.

Also if you force core2 on a P4 system the kernel will just oops
because it will access MSRs that are not there. So I don't think
that's a good idea.

It means you have to update oprofile userland at least once until
you have arch perfmon support, but I think even Linus will be able
to do that :) Hopefully Maynard will do a new release soon.

The force of core2 is nacked from my side.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
