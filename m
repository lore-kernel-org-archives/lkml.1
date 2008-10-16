Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYJPWz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYJPWz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYJPWzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:55:46 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51034 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755075AbYJPWzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:55:45 -0400
Message-ID: <48F7C69E.3060509@sgi.com>
Date: Thu, 16 Oct 2008 15:56:30 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, adobriyan@gmail.com,
       menage@google.com, pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] seq_file: Add seq_cpumask_list(), seq_nodemask_list()
References: <48F1C375.5020105@cn.fujitsu.com> <20081016125827.d72c52c8.akpm@linux-foundation.org>
In-Reply-To: <20081016125827.d72c52c8.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sun, 12 Oct 2008 17:29:25 +0800
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> +static inline int seq_cpumask_list(struct seq_file *m, cpumask_t *mask)
>> +{
>> +	return seq_bitmap_list(m, mask->bits, NR_CPUS);
>> +}
> 
> Is it possible to avoid using NR_CPUS?  In some situations it'd be much
> more efficient to use the runtime-determined max possible cpu index.
> 
> But I don't immediately recall how to get at that number. 
> num_possible_cpus() assumes that there are no holes in the CPU
> identifier list.
> 

nr_cpu_ids represents the max index +1 of the possible cpus.  (Usually the
same as num_possible_cpus() except a.) it doesn't need to do the cpus_weight()
op, and b.) *if* (a big if) the cpu indices are sparse, then they wouldn't
be the same values.)

Thanks,
Mike
