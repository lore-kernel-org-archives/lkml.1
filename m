Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbXKMTo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbXKMTo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:44:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761479AbXKMToE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:44:04 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760962AbXKMToB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:44:01 -0500
Date: Tue, 13 Nov 2007 11:38:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: tigran@aivazian.fsnet.co.uk, viro@ftp.linux.org.uk,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUGS][PATCH] Fixes to the BFS filesystem driver
Message-Id: <20071113113852.386219f6.akpm@linux-foundation.org>
In-Reply-To: <4739D1A0.20805@gmail.com>
References: <4739D1A0.20805@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 19:32:32 +0300 Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:

> Hi Tigran,
> 
> I found a few bugs in the BFS driver. Detailed description of the bugs as well as the steps to reproduce the errors are given in the kernel bugzilla. Please follow these links for more information:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9363
> http://bugzilla.kernel.org/show_bug.cgi?id=9364
> http://bugzilla.kernel.org/show_bug.cgi?id=9365
> http://bugzilla.kernel.org/show_bug.cgi?id=9366
> 
> The patch included in this email fixes the bugs described above. Besides, the patch introduces coding style changes to make the BFS driver conform to the requirements specified for Linux kernel code. Finally, I made a few cosmetic changes such as removal of trivial debug output.
> 
> Also, the patch removes the fields `si_lf_ioff' and `si_lf_sblk' of the in-core superblock structure. These fields are initialized but never actually used.
> 
> If you are wondering why I need BFS, here is the answer: I am using this driver in the context of Linux kernel classes I am teaching in the Moscow State University and in the International Institute of Information Technology in Pune, India.

I was wondering ;)  BFS users aren't common.  Thanks for the fixes.

For future reference: we prefer that an individual patch not do more than
one thing.  So it would have been preferable to present this work as a
sequence of patches.

Probably the high-priority patches (ie: bugfixes) should be the earlier
patches in a case like this.  Because then we can backport the fix into
2.6.23 and maybe 2.6.22 with some confidence.  Also, separating out the
cleanups for the bugfixes makes it easier for people to review and
understand the bugfixes.


Still, that's a minor detail compared to getting a filesystem bug fixed so
I merged your change as-is, thanks

