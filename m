Return-Path: <linux-kernel-owner+w=401wt.eu-S1761354AbXKOPie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761354AbXKOPie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 10:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbXKOPi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 10:38:26 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:44738 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbXKOPiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 10:38:25 -0500
Date: Thu, 15 Nov 2007 15:37:48 +0000
From: Ralf Baechle DL5RB <ralf@linux-mips.org>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 2/3] cpu-hotplug: Replace lock_cpu_hotplug() with
	get_online_cpus()
Message-ID: <20071115153748.GD4973@linux-mips.org>
References: <20071115134924.GA15282@in.ibm.com> <20071115135202.GB15462@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115135202.GB15462@in.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 07:22:02PM +0530, Gautham R Shenoy wrote:

> Replace all lock_cpu_hotplug/unlock_cpu_hotplug from the kernel and use
> get_online_cpus and put_online_cpus instead as it highlights
> the refcount semantics in these operations.
> 
> The new API guarantees protection against the cpu-hotplug operation,
> but it doesn't guarantee serialized access to any of the local data
> structures. Hence the changes needs to be reviewed.
> 
> In case of pseries_add_processor/pseries_remove_processor, use
> cpu_maps_update_begin()/cpu_maps_update_done() as we're modifying the
> cpu_present_map there.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
>  Documentation/cpu-hotplug.txt                |   11 ++++++-----
>  arch/mips/kernel/mips-mt-fpaff.c             |   10 +++++-----

Acked-by: Ralf Baechle <ralf@linux-mips.org>

for the MIPS part.

  Ralf
