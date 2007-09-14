Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbXINXcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbXINXcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 19:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXINXck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 19:32:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180AbXINXcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 19:32:39 -0400
Date: Fri, 14 Sep 2007 16:32:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: travis@sgi.com
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 00/10] x86: Reduce Memory Usage and Inter-Node message
 traffic (v3)
Message-Id: <20070914163223.20759e54.akpm@linux-foundation.org>
In-Reply-To: <20070912015644.927677070@sgi.com>
References: <20070912015644.927677070@sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 18:56:44 -0700
travis@sgi.com wrote:

> Changes for version v3:
> 
> cpu_sibling_map has been converted to a per_cpu data array to fix
> build errors on ia64, ppc64 and sparc64 to accomodate references in
> block/blktrace.c and kernel/sched.c when CONFIG_SCHED_SMT is defined.
> 
> Warning: ppc64 and sparc64 have not yet been built nor tested.

These patches all seem to be unaltered from what I had.

The first patch (x86: remove x86_cpu_to_log_apicid array) is in Andi's
tree as x86_64-mm-remove-x86_cpu_to_log_apicid.patch so I don't apply that.

The sparc64/ppc64/ia64 convert-cpu_sibling_map-to-a-per_cpu-data-array
patches need to be folded into the base patch so that we don't break the build
at any stage.

So what I ended up with was

x86-fix-cpu_to_node-references.patch
x86-convert-cpu_core_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-be-a-per-cpu-variable.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ia64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-sparc64.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch

where the four convert-cpu_sibling_map-to-* will be clumped into a
single diff.
