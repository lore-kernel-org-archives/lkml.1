Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYBSPki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYBSPki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYBSPkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:40:03 -0500
Received: from relay2.sgi.com ([192.48.171.30]:59409 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755899AbYBSPkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:40:01 -0500
Date: Tue, 19 Feb 2008 09:39:58 -0600
From: Paul Jackson <pj@sgi.com>
To: Nick Andrew <nick@nick-andrew.net>, "Paul Menage" <menage@google.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Improve init/Kconfig help descriptions [PATCH 6/9]
Message-Id: <20080219093958.57144ce3.pj@sgi.com>
In-Reply-To: <20080219151214.GD27352@tull.net>
References: <20080219140609.GA26619@tull.net>
	<20080219151214.GD27352@tull.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for doing this, Nick.  One area looks like some details
need working.

Nick Andrew wrote:
>  config PROC_PID_CPUSET
>  	bool "Include legacy /proc/<pid>/cpuset file"
>  	depends on CPUSETS
>  	default y
> +	help
> +	  This option provides the legacy /proc/<pid>/cpuset file.
> +
> +	  It has been deprecated in favour of an additional line
> +	  in /proc/<pid>/status showing on which CPUs a process
> +	  may be scheduled.

I don't think /proc/<pid>/cpuset (PROC_PID_CPUSET) is, or should be,
deprecated.

Actually, I'd be inclined toward removing this CONFIG option, and
making /proc/<pid>/cpuset a non-optional consequence of enabling
cpusets ... so I'm adding Paul Menage to the CC list, in case he has
thoughts or insights on this.  The duplication of this bit of information
between both /proc/<pid>/cpuset and one line of /proc/<pid>/status is a
minor and harmless wart, resulting from the evolution of cgroups from
cpusets, that is not worth bothering kernel configuration users with
questions about.

And isn't that a line in /proc/<pid>/cgroup, not in /proc/<pid>/status ?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
