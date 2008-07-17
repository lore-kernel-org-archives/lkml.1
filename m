Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbYGQUJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbYGQUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 16:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757244AbYGQUJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 16:09:22 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43379 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756246AbYGQUJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 16:09:21 -0400
Date: Thu, 17 Jul 2008 15:09:16 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: seto.hidetoshi@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       menage@google.com, peterz@infradead.org, akpm@linux-foundation.org,
       laijs@cn.fujitsu.com
Subject: Re: [RFC] [PATCH] cpuset: fix wrong calculation of relax domain
 level
Message-Id: <20080717150916.bf0ca765.pj@sgi.com>
In-Reply-To: <487F1B38.3050100@cn.fujitsu.com>
References: <487EFDD0.2060101@cn.fujitsu.com>
	<487F0996.9010904@jp.fujitsu.com>
	<487F1B38.3050100@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In looking at this, I notice something I should have questioned before.

The include/linux/sched.h code:

    struct sched_domain_attr {
	    int relax_domain_level;
    };

    #define SD_ATTR_INIT    (struct sched_domain_attr) {    \
	    .relax_domain_level = -1,                       \
    }                                                                                                                                 

and the associated passing of relax_domain_level's embedded inside
a kmalloc'c struct sched_domain_attr 'dattr' seems like excessive
obfuscating apparatus to me.  Unless someone has short term plans
to be adding some other attributes to this sched_domain_attr, I
suspect it would make more sense just to pass relax_domain_level's
as explicit lvalues, dropping all this attr stuff.

Adding unnecessary abstractions 'for future growth' is usually a
bad idea.  It impedes current code understanding more than it aids
future code growth.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
