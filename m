Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbXLTLhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbXLTLhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756993AbXLTLho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:37:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbXLTLhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:37:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071219220307.d69c0fde.akpm@linux-foundation.org>
References: <20071219220307.d69c0fde.akpm@linux-foundation.org> <a44ae5cd0712192040k7480682eoa29f33d70a91c618@mail.gmail.com> <4769F409.6030300@gmail.com> <4769FF37.5060308@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Miles Lane <miles.lane@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: OOPS: 2.6.24-rc5-mm1 -- EIP is at r_show+0x2a/0x70 -- (triggered by "cat /proc/iomem")
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Thu, 20 Dec 2007 11:37:20 +0000
Message-ID: <5102.1198150640@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> I would be suspecting iget-stop-procfs-from-using-iget-and-read_inode.patch.

I think your suspicions are very unlikely.  The patch only affects
proc_get_inode() - and looking at the patch backtrace, it looks like the
system is successfully past that already (it's unlikely that
proc_reg_read+0x60/0x74 would have been reached otherwise).

If my patch to procfs is wrong, it would affect all proc files and ought be
immediately detectable.

David
