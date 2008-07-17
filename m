Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYGQHRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYGQHRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbYGQHRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:17:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbYGQHR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:17:29 -0400
Date: Thu, 17 Jul 2008 00:16:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       ltt-dev@lists.casi.polymtl.ca, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix markers duplicate modpost entry
Message-Id: <20080717001613.8fe204df.akpm@linux-foundation.org>
In-Reply-To: <20080717070321.GB26035@Krystal>
References: <20080715024754.GA26471@Krystal>
	<000001c8e7aa$b9548600$2bfd9200$@css.fujitsu.com>
	<20080717024550.GA22869@Krystal>
	<487ED503.2060503@oracle.com>
	<20080717070321.GB26035@Krystal>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 03:03:21 -0400 Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> When a kernel was rebuilt, the previous Module.markers was not cleared. It
> caused markers with different format strings to appear as duplicates when a
> markers was changed.
> 
> I merely merged the patches from Roland and Wenji here. It applies to
> mainline (and is not intrusive, so will also apply to linux-next).

Is this fix needed in 2.6.26.x?  2.6.25.x?

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> From: Roland McGrath <roland@redhat dot com>
> From: Wenji Huang <wenji.huang@oracle.com>
> CC: akpm@linux-foundation.org

whoa, what's all that about?

Patches can only have one Author: in git, and we indicate that in
emails by putting a From: line right at the top of the changelog. 
(Additional credits can and should be mentioned in the changelog text
of course).  When that From: line is missing we take the authorship
info from the email headers.

So according to the above, this patch has three authors.  Geeze, even I
can type faster than that!

Who wrote it?

> ---
>  scripts/Makefile.modpost |    1 +
>  scripts/mod/modpost.c    |    3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/scripts/Makefile.modpost
> ===================================================================
> --- linux-2.6-lttng.orig/scripts/Makefile.modpost	2008-07-17 02:47:44.000000000 -0400
> +++ linux-2.6-lttng/scripts/Makefile.modpost	2008-07-17 02:48:17.000000000 -0400
> @@ -101,6 +101,7 @@ quiet_cmd_kernel-mod = MODPOST $@
>        cmd_kernel-mod = $(modpost) $@
>  
>  vmlinux.o: FORCE
> +	@rm -fr $(kernelmarkersfile)
>  	$(call cmd,kernel-mod)
>  
>  # Declare generated files as targets for modpost
> Index: linux-2.6-lttng/scripts/mod/modpost.c
> ===================================================================
> --- linux-2.6-lttng.orig/scripts/mod/modpost.c	2008-07-17 02:49:33.000000000 -0400
> +++ linux-2.6-lttng/scripts/mod/modpost.c	2008-07-17 02:50:10.000000000 -0400
> @@ -1992,7 +1992,8 @@ static void read_markers(const char *fna
>  			mod->skip = 1;
>  		}
>  
> -		add_marker(mod, marker, fmt);
> +		if (!mod->skip)
> +			add_marker(mod, marker, fmt);
>  	}
>  	return;
>  fail:

