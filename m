Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYI3VTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYI3VTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 17:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYI3VS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 17:18:58 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:53050 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754010AbYI3VS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 17:18:57 -0400
Date: Tue, 30 Sep 2008 17:18:54 -0400
From: Theodore Tso <tytso@mit.edu>
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David.Madore@ens.fr
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Message-ID: <20080930211854.GZ10831@mit.edu>
Reply-To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Mail-Followup-To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Quentin Godfroy <godfroy@clipper.ens.fr>,
	linux-fsdevel@vger.kernel.org, David.Madore@ens.fr
References: <20080930202728.GA6358@goelette.ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080930202728.GA6358@goelette.ens.fr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Reply-to set to linux-ext4@vger.kernel.org ]

On Tue, Sep 30, 2008 at 10:27:29PM +0200, Quentin Godfroy wrote:
> Hi lists,
> I'd like to report the following problem : after ~ 10 days' uptime on a
> Debian 2.6.26-1-686 kernel, my system becomes extremely sluggish and
> unresponsive and the OOM-killer starts targeting even innocent processes like
> identd or rsync (when the swap is disabled). The machine is low on RAM (192
> MB) but this has never been a problem before. As for the slowness, strace
> shows that the brk() syscall takes ages to complete; the blocking processes
> are in the D state (and for some reason the kernel gives no wchan info).
>
> Config has nothing unusual except that all fs are ext4, which I am begining
> to suspect may be the culprit, as every night some process stat()s and
> read()s something like 850,000 files, which is maybe fs-stressing; also,
> umounting then remounting /home makes the 'buffers' drop from 127304 to
> 55920 and partially solves the problem.
>
> Free reports a large and constantly growing 'buffers' figure (more than
> 50% of the available memory). No userland processes seems to be consuming
> lare amounts of memory (sum of RSS in 'ps aux' is about 30 megs), and the
> overall system is mostly idle.
> 
> for instance, the following command reports 
> 
> $ free ; dpkg -l '*' >/dev/null; dmesg | tail -n 2
>              total       used       free     shared    buffers     cached
> Mem:        190356     178920      11436          0     126104      12520
> -/+ buffers/cache:      40296     150060
> Swap:            0          0          0
> /* Waits a minute or so */
> Killed
> [811245.911859] Out of memory: kill process 6639 (dpkg-query) score 7292 or a child
> [811245.911972] Killed process 6639 (dpkg-query)
> 

Can you send the output of /proc/meminfo and /proc/slabinfo?

						- Ted
