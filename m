Return-Path: <linux-kernel-owner+w=401wt.eu-S2992812AbXDTJbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992812AbXDTJbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992786AbXDTJbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:31:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41298 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992778AbXDTJbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:31:47 -0400
Date: Fri, 20 Apr 2007 10:34:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [d_path 6/7] Filter out disconnected paths from /proc/mounts
Message-ID: <20070420103429.72efe1dc@the-village.bc.nu>
In-Reply-To: <20070419234704.448790135@schurl.suse.de>
References: <20070412090809.917795000@suse.de>
	<200704170335.21805.agruen@suse.de>
	<20070417182126.2327d89d@the-village.bc.nu>
	<20070419232303.300441585@schurl.suse.de>
	<20070419234704.448790135@schurl.suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There is some disagreement what /proc/mounts should include. Currently it
> reports all mounts from the current namespace and doesn't include lazy
> unmounts. This leads to ambiguities with the rootfs (which is an internal mount
> irrelevant to user-space except in the initrd), and in chroots.
> 
> With this and the next patch, /proc/mounts only reports the mounts reachable
> for the current process, which makes a lot more sense IMO.  If the current
> process is rooted in the namespace root (which it usually is), it will see all
> mounts except for the rootfs.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

This change in behaviour appears to be fine for glibc (except when trying
to find the name of a file from a namespace we are not in, which wouldn't
have come out right before either)

Acked-by: Alan Cox <alan@redhat.com>

(but still NAK on the getcwd change)
