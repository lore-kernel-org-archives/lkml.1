Return-Path: <linux-kernel-owner+w=401wt.eu-S2992784AbXDTJaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992784AbXDTJaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992778AbXDTJaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:30:09 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43248 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992742AbXDTJaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:30:07 -0400
Date: Fri, 20 Apr 2007 10:32:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [d_path 1/7] Fix __d_path() for lazy unmounts and make it
 unambiguous
Message-ID: <20070420103216.781f4298@the-village.bc.nu>
In-Reply-To: <20070419234703.909398619@schurl.suse.de>
References: <20070412090809.917795000@suse.de>
	<200704170335.21805.agruen@suse.de>
	<20070417182126.2327d89d@the-village.bc.nu>
	<20070419232303.300441585@schurl.suse.de>
	<20070419234703.909398619@schurl.suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 01:23:04 +0200
Andreas Gruenbacher <agruen@suse.de> wrote:

> First, when __d_path() hits a lazily unmounted mount point, it tries to prepend
> the name of the lazily unmounted dentry to the path name.  It gets this wrong,
> and also overwrites the slash that separates the name from the following
> pathname component. This patch fixes that; if a process was in directory
> /foo/bar and /foo got lazily unmounted, the old result was ``foobar'' (note the
> missing slash), while the new result with this patch is ``foo/bar''.

ACK the fix

> of ``foobar'' in the example described above.  Subsequent patches propose to
> make getcwd() fail instead of reporting unreachable paths like this one and
> hide unreachable mount points from /proc/mounts.

NAK that change of behaviour on the following patches.
