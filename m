Return-Path: <linux-kernel-owner+w=401wt.eu-S1758704AbYJPXIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758704AbYJPXIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 19:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYJPXIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 19:08:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755789AbYJPXIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 19:08:25 -0400
Date: Thu, 16 Oct 2008 16:08:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: laijs@cn.fujitsu.com, adobriyan@gmail.com, menage@google.com, pj@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] seq_file: Add seq_cpumask_list(),
 seq_nodemask_list()
Message-Id: <20081016160813.b7ee423f.akpm@linux-foundation.org>
In-Reply-To: <48F7C69E.3060509@sgi.com>
References: <48F1C375.5020105@cn.fujitsu.com>
	<20081016125827.d72c52c8.akpm@linux-foundation.org>
	<48F7C69E.3060509@sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2008 15:56:30 -0700
Mike Travis <travis@sgi.com> wrote:

> Andrew Morton wrote:
> > On Sun, 12 Oct 2008 17:29:25 +0800
> > Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> > 
> >> +static inline int seq_cpumask_list(struct seq_file *m, cpumask_t *mask)
> >> +{
> >> +	return seq_bitmap_list(m, mask->bits, NR_CPUS);
> >> +}
> > 
> > Is it possible to avoid using NR_CPUS?  In some situations it'd be much
> > more efficient to use the runtime-determined max possible cpu index.
> > 
> > But I don't immediately recall how to get at that number. 
> > num_possible_cpus() assumes that there are no holes in the CPU
> > identifier list.
> > 
> 
> nr_cpu_ids represents the max index +1 of the possible cpus.  (Usually the
> same as num_possible_cpus() except a.) it doesn't need to do the cpus_weight()
> op, and b.) *if* (a big if) the cpu indices are sparse, then they wouldn't
> be the same values.)

OK, thanks.  I was foggily looking for max_possible_cpus(), to match
num_online_cpus(), num_possible_cpus(), num_present_cpus().  Silly me.

