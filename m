Return-Path: <linux-kernel-owner+w=401wt.eu-S1422761AbYHFUhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422761AbYHFUhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758179AbYHFUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:37:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59848 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758991AbYHFUhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:37:03 -0400
Date: Wed, 6 Aug 2008 15:37:00 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: rakib.mullick@gmail.com, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset : Handling improper memory allocation.
Message-Id: <20080806153700.dc12e5dc.pj@sgi.com>
In-Reply-To: <489A05EF.7000108@qualcomm.com>
References: <b9df5fa10808061022r34e3a009k5060c8fab06bcd5c@mail.gmail.com>
	<489A05EF.7000108@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> partition_sched_domains() can deal with attrs==NULL case. So we do not
> have to abort domain building.

This might be a good place for a comment, since unchecked kmalloc()
calls look dangerous:

	/* Convert <csn, csa> to <ndoms, doms> */
	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
	if (!doms)
		goto rebuild;
	dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);
	/* dattr == NULL is ok; partition_sched_domains() can cope with it. */

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
