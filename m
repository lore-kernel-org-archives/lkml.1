Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525AbYG1FPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbYG1FPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 01:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbYG1FPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 01:15:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52595 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750920AbYG1FPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 01:15:32 -0400
Date: Mon, 28 Jul 2008 00:15:30 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpuset: fix wrong calculation of relax domain level
Message-Id: <20080728001530.bf7f5e44.pj@sgi.com>
In-Reply-To: <488D3331.8000306@cn.fujitsu.com>
References: <488D3331.8000306@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems ok to me:

Reviewed-by: Paul Jackson <pj@sgi.com>


Li Zefan wrote:
> -			update_domain_attr(dattr, &top_cpuset);
> +			update_domain_attr_tree(dattr, &top_cpuset);

Does this change mean that there is now only -one- place that calls
"update_domain_attr()", that being "update_domain_attr_tree()" ?

If so, then perhaps:
 1) "update_domain_attr()" could be removed as a separate routine,
    with its code folded into "update_domain_attr_tree()".
 2) a proper opening comment could be provided "update_domain_attr()",
    stating what it does, and its locking needs.

The above, if it makes sense, would be an additional PATCH, on top
of your present patches, further refining them.


Separate topic ...

It bothers me a little that there is a generic 'attributes' and related
*_attr() and dattr variable names, all speaking of some set of multiple
generic attributes, such as in:

        struct sched_domain_attr *dattr;  /* attributes for custom domains */

even though, when all is said and done, there is only one attribute,
the relax_domain_level.  The generic, content-free word 'attributes'
just obfuscates the single specific value, relax_domain_level, being
managed here.

... However, I'm too lazy to propose a patch to mess with this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
