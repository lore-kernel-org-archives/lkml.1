Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbXDPD4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbXDPD4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 23:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbXDPD4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 23:56:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754436AbXDPD4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 23:56:08 -0400
Date: Sun, 15 Apr 2007 23:56:03 -0400
From: Dave Jones <davej@redhat.com>
To: Zach Carter <linux@zachcarter.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: BUG:  Bad page state errors during kernel make
Message-ID: <20070416035603.GD21217@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Zach Carter <linux@zachcarter.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
References: <4622EDD3.9080103@zachcarter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4622EDD3.9080103@zachcarter.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 08:30:27PM -0700, Zach Carter wrote:

 > Console Messages:
 > Bad page state in process 'cc1'
 > page:c1ca88e8 flags:0x52000000 mapping:c1000000 mapcount:0 count:0
 > Trying to fix it up, but a reboot is needed
 > Backtrace:
 >   [<c015625d>] bad_page+0x5e/0x89
 >   [<c0156ab1>] get_page_from_freelist+0x1de/0x298
 >   [<c0156bd3>] __alloc_pages+0x68/0x2aa
 >   [<c016322a>] anon_vma_prepare+0x20/0xb8
 >   [<c0129647>] tasklet_action+0x4b/0xa4
 >   [<c015e336>] __handle_mm_fault+0x3b2/0x88f
 >   [<c0116dce>] smp_apic_timer_interrupt+0x6e/0x7a
 >   [<c01380d7>] hrtimer_run_queues+0x138/0x152
 >   [<c0315e4a>] do_page_fault+0x23f/0x53c
 >   [<c0315c0b>] do_page_fault+0x0/0x53c
 >   [<c031488c>] error_code+0x7c/0x84
 >   =======================
 > list_del corruption. prev->next should be c21a4628, but was e21a4628

'c' became 'e' in that last address. A single bit flipped.
Given you've had this for some time, this smells like a hardware problem.
memtest86+ will probably show up something.

	Dave

-- 
http://www.codemonkey.org.uk
