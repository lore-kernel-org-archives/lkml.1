Return-Path: <linux-kernel-owner+w=401wt.eu-S933644AbXHJCN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbXHJCN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757989AbXHJCNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:13:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48366 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756403AbXHJCNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:13:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: YOSHIFUJI Hideaki / =?utf-8?B?5ZCJ6Jek6Iux5piO?= 
	<yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org, devel@openvz.org, adobriyan@sw.ru,
       netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH 04/10] sysctl: Fix neighbour table sysctls.
References: <m18x8k9ppv.fsf_-_@ebiederm.dsl.xmission.com>
	<m14pj89pmt.fsf_-_@ebiederm.dsl.xmission.com>
	<m1zm108axi.fsf_-_@ebiederm.dsl.xmission.com>
	<20070810.104710.28739250.yoshfuji@linux-ipv6.org>
	<20070809185521.c3ab1afd.akpm@linux-foundation.org>
Date: Thu, 09 Aug 2007 20:12:14 -0600
In-Reply-To: <20070809185521.c3ab1afd.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 9 Aug 2007 18:55:21 -0700")
Message-ID: <m11wec87ep.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> But it is good to remove bad interfaces, if we possibly can.
>
> It is worth making the attempt.  Does anyone know of anything which will
> break?  I fed NET_NEIGH_ANYCAST_DELAY at random into
> http://www.google.com/codesearch and came up with nothing...

My current policy is that since I could only find 5 real world linux
programs that even call sys_sysctl, that if I find a broken sysctl
binary interface I'm lazy and just remove it.  The only networking one
I know of is radvd.

Added to that I just pushed an autochecking sysctl patch to Andrew
that fails register_sysctl_table if the sysctl table is broken.  And
all of these showed up.  So some fix was needed or things would have
been even worse.

Eric

