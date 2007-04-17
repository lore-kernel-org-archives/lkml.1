Return-Path: <linux-kernel-owner+w=401wt.eu-S1161098AbXDQRTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161098AbXDQRTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161042AbXDQRTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:19:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46377 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161098AbXDQRTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:19:38 -0400
Date: Tue, 17 Apr 2007 18:21:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [AppArmor 31/41] Fix __d_path() for lazy unmounts and make it
 unambiguous; exclude unreachable mount points from /proc/mounts
Message-ID: <20070417182126.2327d89d@the-village.bc.nu>
In-Reply-To: <200704170335.21805.agruen@suse.de>
References: <20070412090809.917795000@suse.de>
	<200704151940.22528.agruen@suse.de>
	<20070416225748.3e5d3003@the-village.bc.nu>
	<200704170335.21805.agruen@suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> For /proc/mounts, one could argue that the admin might want to see everything, 
> but then that's not actually true even today because /proc/mounts doesn't 
> show lazyily unmounted stuff or mounts from other namespaces, so that 
> everything is quite relative.

The current state is not good either

> The getcwd() case is even stronger as the "see everything" argument makes even 
> less sense there. I really can't see why the kernel should return processes 
> fake pathnames. The process is explicitly asking for the current pathname to 
> the working directory, it doesn't want to know what the pathname was at some 
> previous point in time.

Can you prove no existing application on the planet relies on the
existing behaviour ? Actually more limited but sane as a test would be
"Can you prove that the glibc behaviour visible to applications does not
change"

> Actually, no. We could live fine with leaving getcwd() and /proc/mounts as 
> ambiguous / weird / broken as they are right now. All it would take would be 
> to reambiguate the result of the unambiguous __d_path(), which is really 
> easy. Everything that cares about real pathnames would use the unambiguous 
> version while the legacy interfaces would use the ambiguous version. But that 
> really wouldn't make sense.

I disagree - firstly because of not breaking stuff, and secondly because
it separates two discussions - merging AppArmor being one of them , and
the correct behaviour for getcwd & /proc/mounts being the other.

> > Ok, providing the "real" root sees them all it isn't so bad, but to
> > assume you can filter based upon what the task can see is dodgy as an
> > assumption.
> 
> Why?

Because the viewing apparatus on the other side of the monitor is not
operating in current directories/contexts.

Alan
