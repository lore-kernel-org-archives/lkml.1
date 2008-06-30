Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbYF3Tdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbYF3Tdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYF3Tdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:33:40 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54712 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764148AbYF3Tdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:33:39 -0400
Date: Mon, 30 Jun 2008 14:33:34 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: heiko.carstens@de.ibm.com, oleg@tv-sign.ru, akpm@linux-foundation.org,
       ego@in.ibm.com, menage@google.com, peterz@infradead.org,
       vegard.nossum@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] S390 topology: don't use kthread() for
 arch_reinit_sched_domains()
Message-Id: <20080630143334.66033f60.pj@sgi.com>
In-Reply-To: <48692D7C.10403@qualcomm.com>
References: <20080629165132.GA11218@tv-sign.ru>
	<20080630134537.GC7686@osiris.boeblingen.de.ibm.com>
	<48692D7C.10403@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> we either have to ... or change arch_init_sched_domains() to no destroy 
> current domains.

I might be misreading this, but I doubt that just not destroying
current domains is an option.  Once any CPU goes on or off line, the
only way back to the new correct sched domain configuration is via the
rebuild_sched_domains() routine in kernel/cpuset.c.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
