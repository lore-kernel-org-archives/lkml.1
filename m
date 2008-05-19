Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbYESQLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbYESQLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759445AbYESQKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:10:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761445AbYESQKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:10:44 -0400
Date: Mon, 19 May 2008 18:10:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Jackson <pj@sgi.com>
Cc: ying.huang@intel.com, hpa@zytor.com, andi@firstfloor.org,
       akpm@linux-foundation.org, tglx@linutronix.de, steiner@sgi.com,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI
	memory entries to kernel
Message-ID: <20080519161020.GB16164@elte.hu>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com> <20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com> <20080515190340.b232ca7d.pj@sgi.com> <20080516123820.GA16520@elte.hu> <20080518014926.917ca9a7.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080518014926.917ca9a7.pj@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Jackson <pj@sgi.com> wrote:

> Ingo wrote:
> > so double-checking [the merge of my x86 boot patches] would be nice.
> 
> I only see one detail worth mentioning on reading the resulting merge 
> in ingo.tip.
> 
> Shouldn't the static array declarations in arch/x86/kernel/e820.c be 
> indented?  It looks like the -file- static declarations from 
> arch/x86/kernel/e820_32.c (which were not indented) took precedence in 
> the merge over the -function- static declarations from 
> arch/x86/kernel/e820_64.c.  The code, from the perspective of what 
> ends up in the compiled kernel, seems fine -- just the indentation 
> off.
> 
> int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
> 				int *pnr_map)
> {
> 	struct change_member {
> 		struct e820entry *pbios; /* pointer to original bios entry */
> 		unsigned long long addr; /* address for this change point */
> 	};
> static struct change_member change_point_list[2*E820_X_MAX] __initdata;
> static struct change_member *change_point[2*E820_X_MAX] __initdata;
> static struct e820entry *overlap_list[E820_X_MAX] __initdata;
> static struct e820entry new_bios[E820_X_MAX] __initdata;
> 	struct change_member *change_tmp;
> 	unsigned long current_type, last_type;
> 	unsigned long long last_addr;

indeed that's quite off.

	Ingo
