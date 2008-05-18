Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYERGtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYERGtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 02:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYERGtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 02:49:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52882 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751434AbYERGtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 02:49:31 -0400
Date: Sun, 18 May 2008 01:49:26 -0500
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: ying.huang@intel.com, hpa@zytor.com, andi@firstfloor.org,
       akpm@linux-foundation.org, tglx@linutronix.de, steiner@sgi.com,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI
 memory entries to kernel
Message-Id: <20080518014926.917ca9a7.pj@sgi.com>
In-Reply-To: <20080516123820.GA16520@elte.hu>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
	<20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>
	<20080515190340.b232ca7d.pj@sgi.com>
	<20080516123820.GA16520@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> so double-checking [the merge of my x86 boot patches] would be nice.

I only see one detail worth mentioning on reading the resulting merge
in ingo.tip.

Shouldn't the static array declarations in arch/x86/kernel/e820.c
be indented?  It looks like the -file- static declarations
from arch/x86/kernel/e820_32.c (which were not indented) took
precedence in the merge over the -function- static declarations
from arch/x86/kernel/e820_64.c.  The code, from the perspective
of what ends up in the compiled kernel, seems fine -- just the
indentation off.

int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
				int *pnr_map)
{
	struct change_member {
		struct e820entry *pbios; /* pointer to original bios entry */
		unsigned long long addr; /* address for this change point */
	};
static struct change_member change_point_list[2*E820_X_MAX] __initdata;
static struct change_member *change_point[2*E820_X_MAX] __initdata;
static struct e820entry *overlap_list[E820_X_MAX] __initdata;
static struct e820entry new_bios[E820_X_MAX] __initdata;
	struct change_member *change_tmp;
	unsigned long current_type, last_type;
	unsigned long long last_addr;


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
