Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbZGBBgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbZGBBgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbZGBBga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:36:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350AbZGBBg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:36:29 -0400
Date: Wed, 1 Jul 2009 18:34:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: alex.shi@intel.com
Cc: bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       Yinghai Lu <Yinghai@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage
 unusable on non-NUMA machine
Message-Id: <20090701183452.8660c8a9.akpm@linux-foundation.org>
In-Reply-To: <bug-13690-10286@http.bugzilla.kernel.org/>
References: <bug-13690-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Thu, 2 Jul 2009 01:22:24 GMT bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13690
> 
>            Summary: nodes_clear cause hugepage unusable on non-NUMA
>                     machine
>            Product: Platform Specific/Hardware
>            Version: 2.5
>     Kernel Version: 2.6.31-rc1
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: i386
>         AssignedTo: platform_i386@kernel-bugs.osdl.org
>         ReportedBy: alex.shi@intel.com
>                 CC: yinghai@kernel.org
>         Regression: Yes
> 
> 
> 73d60b7f747176dbdff826c4127d22e1fd3f9f74  commit introduced a nodes_clear
> function for NUMA machine. But seems the commit omits non-NUMA machine.
>  If find_zone_movable_pfns_for_nodes/early_calculate_totalpages has no
>  chance to run. nodes_clear will block HUPEPAGE using in my specjbb2005
>  testing on my Stoakely(i386/x86_64), waybridge(i386), IBM T61(i386)
> 
> +       /*
> +        * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
> +        * that node_mask, clear it at first
> +        */
> +       nodes_clear(node_states[N_HIGH_MEMORY]);

Thanks.

fyi, with recently-occurring bugs and regressions of this nature, it is (I
think) best to deal with them via email rather than bugzilla.  Bugzilla is
better-suited to longer-lived bugs where we have a need to track them,
generate statistics, etc.

