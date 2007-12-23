Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXLWWfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXLWWfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 17:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbXLWWfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 17:35:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbXLWWfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 17:35:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc6-mm1: suspend broken on HP nx6325 due to cpufreq changes
Date: Sun, 23 Dec 2007 23:54:40 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712232354.40814.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of December 2007, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> 
> - This kernel doesn't work on i386!
> 
>   It oopses late in boot due to an unrevertable change (e3c1b141) in git-x86
>   which I stared at for a while then I ran out of time and gave up.
> 
>   I would have just abandoned this release until it was fixed but I'll be
>   largely offline for ten days starting tomorrow.
> 
>   The culprits have been notified and hopefully we'll have a patch for
>   hot-fixes/ tomorrow.
> 
>   x86_64 and powerpc work OK though.
> 
> - git-block is dropped due to more conflicts that I'm prepared to repair
>   with git-scsi-misc
> 
> - git-perfmon is dropped due to conflicts with git-x86
> 
> - git-kgdb is dropped due to conflicts with git-x86
> 
> - git-newsetup is dropped due to conflicts with git-x86
> 
> - Andi's x86 quilt tree is dropped due to conflicts with git-x86
> 
> - Someone broke suspend-to-RAM on the t61p again.  It just instantly resumes
>   itself.

Suspend is also broken on my HP nx6325 (hangs hard in the last phase of
suspend) and git-cpufreq.patch is responsible for that (as shown by bisection).

Reverting git-cpufreq.patch makes suspend work again, although it still is a
bit flaky (it takes well more than 5 seconds to suspend and the sound adapter
doesn't work right after the resume, but it starts to work again about 10s
later).

Thanks,
Rafael
