Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYG2NLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYG2NLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYG2NLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:11:42 -0400
Received: from relay2.sgi.com ([192.48.171.30]:47059 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752032AbYG2NLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:11:41 -0400
Date: Tue, 29 Jul 2008 08:11:39 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com,
       seto.hidetoshi@jp.fujitsu.com, laijs@cn.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cpuset: fix wrong calculation of relax domain level
Message-Id: <20080729081139.c858ddbe.pj@sgi.com>
In-Reply-To: <488E7D92.8020501@cn.fujitsu.com>
References: <488D3331.8000306@cn.fujitsu.com>
	<20080728001530.bf7f5e44.pj@sgi.com>
	<488E7D92.8020501@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> > If so, then perhaps:
> >  1) "update_domain_attr()" could be removed as a separate routine,
> >     with its code folded into "update_domain_attr_tree()".
> 
> It will be folded into update_domain_attr_tree() by gcc.

My (mild) preference for folding "update_domain_attr()" into
"update_domain_attr_tree()" was not to save runtime CPU cycles.
This is not a hot code path.  It was to improve code readability.

Do what you think is best here ... I'm easy.

> I think update_domain_attr_tree() rather than update_domain_attr() needs
> a comment to state what is does, but as it is a helper function for
> rebuild_sched_domains(), I don't think we need to state its locking needs.

Then perhaps one could include in the comment for
"update_domain_attr_tree()" that it is a helper function
for rebuild_sched_domains(), where its locking is described.

--
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
