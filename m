Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbYG2CTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbYG2CTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYG2CS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:18:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55726 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbYG2CSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:18:55 -0400
Message-ID: <488E7D92.8020501@cn.fujitsu.com>
Date: Tue, 29 Jul 2008 10:16:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpuset: fix wrong calculation of relax domain level
References: <488D3331.8000306@cn.fujitsu.com> <20080728001530.bf7f5e44.pj@sgi.com>
In-Reply-To: <20080728001530.bf7f5e44.pj@sgi.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Seems ok to me:
> 
> Reviewed-by: Paul Jackson <pj@sgi.com>
> 
> 
> Li Zefan wrote:
>> -			update_domain_attr(dattr, &top_cpuset);
>> +			update_domain_attr_tree(dattr, &top_cpuset);
> 
> Does this change mean that there is now only -one- place that calls
> "update_domain_attr()", that being "update_domain_attr_tree()" ?
> 
> If so, then perhaps:
>  1) "update_domain_attr()" could be removed as a separate routine,
>     with its code folded into "update_domain_attr_tree()".

It will be folded into update_domain_attr_tree() by gcc.

>  2) a proper opening comment could be provided "update_domain_attr()",
>     stating what it does, and its locking needs.
> 

I think update_domain_attr_tree() rather than update_domain_attr() needs
a comment to state what is does, but as it is a helper function for
rebuild_sched_domains(), I don't think we need to state its locking needs.

> The above, if it makes sense, would be an additional PATCH, on top
> of your present patches, further refining them.
> 
> 
> Separate topic ...
> 
> It bothers me a little that there is a generic 'attributes' and related
> *_attr() and dattr variable names, all speaking of some set of multiple
> generic attributes, such as in:
> 
>         struct sched_domain_attr *dattr;  /* attributes for custom domains */
> 
> even though, when all is said and done, there is only one attribute,
> the relax_domain_level.  The generic, content-free word 'attributes'
> just obfuscates the single specific value, relax_domain_level, being
> managed here.
> 
> ... However, I'm too lazy to propose a patch to mess with this.
> 

But it doesn't bother me. ;)

IMO it's not good to mess things up by sending a patch to just rename all
the sched_domain_attr to relax_domain_level without doing anything other
useful work.
