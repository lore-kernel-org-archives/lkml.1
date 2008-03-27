Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbYC0JCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbYC0JCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYC0JCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:02:22 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59606 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754773AbYC0JCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:02:21 -0400
Date: Thu, 27 Mar 2008 04:02:16 -0500
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: ying.huang@intel.com, hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/4] x86_64 boot: Add linked listof struct
 setup_data to boot protocol
Message-Id: <20080327040216.99dcde7b.pj@sgi.com>
In-Reply-To: <20080327083221.GD15626@elte.hu>
References: <1206601743.3067.20.camel@caritas-dev.intel.com>
	<20080327083221.GD15626@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo asked:
> what happens with the SGI machine

Unless I misunderstand your post, Ingo, you don't need an SGI machine
for this one, ... just a compiler ;).

In the file arch/x86/boot/main.c, see the line:

    BUILD_BUG_ON(sizeof boot_params != 4096);

This BUILD_BUG is serving as a reminder that the PC's "zero page", such
as is encoded in the struct boot_params (include/asm-x86/bootparam.h)
has to be exactly 4096 bytes by traditional PC architecture.  One of
the entries in that struct is:

    struct e820entry e820_map[E820MAX];             /* 0x2d0 */

H. Peter Anvin, Andi Kleen and Huang had further discussion in an
earlier email thread as to how to best extend this limit.  I trust
that Huang's patch represents their concensus of that discussion.

By the way, Peter, do you have any idea what that E820NR define is
doing in include/asm-x86/e820.h ... it looks like useless redundancy
to me?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
