Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbYFWIt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbYFWIt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYFWItQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:49:16 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47818 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbYFWItP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:49:15 -0400
Subject: Re: /proc 2.6.24 changes for guest CPU accounting
From: Laurent Vivier <Laurent.Vivier@bull.net>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>, ap@zip.com.au,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <485DFFB4.3080008@gmail.com>
References: <485DFFB4.3080008@gmail.com>
Content-Type: text/plain; charset=UTF-8
Organization: Bull S.A.S.
Date: Mon, 23 Jun 2008 10:48:45 +0200
Message-Id: <1214210925.3838.7.camel@frecb07144>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 22 juin 2008 à 09:31 +0200, Michael Kerrisk a écrit :
> Hi Laurent,

Hi Michael,

> A note and patch from Samuel alerted me to your commits
> 9ac52315d4cf5f561f36dabaf0720c00d3553162 and
> 5e84cfde51cf303d368fcb48f22059f37b3872de, which in 2.6.24 changed /proc/stat
> and /proc/PID/stat.  Would you please CC me on kernel-userspace interface
> changes, so that they have a chance of getting documented in man-pages.
> 
> (I see that Andrew P tried to get something added to
> Documentation/filesystems/proc.txt, but that doesn't seem to have made it in.)
> 
> Below is a patch against the proc.5 man page by Samuel and I to document these
> changes.  Do the changes look okay to you?  The first part is the change for
> /proc/<pid>/stat, and the other is for /proc/stat.

Thank you for that. It seems correct to me (except a typo).

You must also notes that "user time" includes "guest time", if you want
real "user time" you must subtract "guest time".
The "guest time" is included in "user time" to not loose it when the
"reader" is not aware of the "guest time".

> Cheers,
> 
> Michael

Thank you,
Laurent
 
> 
> 
> ===================================================================
> --- proc.5      (revision 4046)
> +++ proc.5      (working copy)
> @@ -753,6 +753,13 @@
>   .TP
>   \fIdelayacct_blkio_ticks\fP %llu (since Linux 2.6.18)
>   Aggregated block I/O delays, measured in clock ticks (centiseconds).
> +.TP
> +\fIguest_time\fP %lu (since Linux 2.6.24)
> +Guest time of the process (time spent running a virtual CPU
> +for a guest operating system), in centiseconds.
> +.TP
> +\fIcguest_time\fP %ld (since Linux 2.6.24)
> +Guest time of the process's children, in centiseconds.
>   .RE
>   .TP
>   .I /proc/[number]/statm
> @@ -1510,6 +1517,12 @@
>   .I steal
>   \- stolen time, which is the time spent in other operating systems when
>   running in a virtualized environment
> +
> +Since Linux 2.6.24, there is a ninth column,
> +.IR guest ,
> +which is the time spent running a virtual CPU for guest
> +operating systems under teh control of the Linux kernel.

typo: "teh" -> "the"

> +.\" See Changelog entry for 5e84cfde51cf303d368fcb48f22059f37b3872de
>   .TP
>   \fIpage 5741 1808\fP
>   The number of pages the system paged in and the number that were paged
> 
> 
> 
> 
-- 
------------- Laurent.Vivier@bull.net ---------------
"The best way to predict the future is to invent it."
- Alan Kay

