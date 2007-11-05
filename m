Return-Path: <linux-kernel-owner+w=401wt.eu-S1756868AbXKEO1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868AbXKEO1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 09:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbXKEO1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 09:27:33 -0500
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:59371
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbXKEO1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 09:27:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: RFC: Reproducible oops with lockdep on count_matching_names()
Date: Mon, 5 Nov 2007 15:26:40 +0100
User-Agent: KMail/1.9.6
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "Michael Wu" <flamingice@sourmilk.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org, "Michael Chan" <mchan@broadcom.com>,
       netdev@vger.kernel.org, "Christoph Lameter" <clameter@sgi.com>
References: <20071101191716.GA3201@pogo> <200711051403.39479.mb@bu3sch.de> <84144f020711050556m6675ea90g1b6c8054a3940ec0@mail.gmail.com>
In-Reply-To: <84144f020711050556m6675ea90g1b6c8054a3940ec0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711051526.41273.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 November 2007 14:56:22 Pekka Enberg wrote:
> Hi Michael,
> 
> On Monday 05 November 2007 13:23:50 Pekka Enberg wrote:
> > > Is CONFIG_DEBUG_SLAB enabled? Usually these kind of random corruptions
> > > are caused by someone passing a bad pointer to kfree() or
> > > kmem_cache_free().
> 
> On 11/5/07, Michael Buesch <mb@bu3sch.de> wrote:
> > Yeah.
> >
> > What I also saw was random "one-bit-errors" once and then on rmmod of modules.
> > I have absolutely no idea how they were caused, though (I read the freeing
> > codes of the stuff hundreds of times). I don't have any of the oops messages
> > anymore.
> > But I do _not_ see this behaviour with slub anymore.
> 
> It is possible that the corruption is still there but SLUB doesn't
> show it. Have you tried with slub_debug enabled?

Hm, I don't really remember. Though, I usually have all almost kernel-hacking
options enabled.
I'll check and enable some more.

> > BUG: unable to handle kernel paging request at virtual address f88a4a05
> > printing eip: f88a4a05 *pde = 02000067 *pte = 00000000
> >
> > EIP: 0060:[<f88a4a05>] EFLAGS: 00010086 CPU: 0
> > EIP is at 0xf88a4a05
> > EAX: c20b75c8 EBX: c2f86f38 ECX: f88a4a05 EDX: c2f86f38
> > ESI: c20b75c8 EDI: c2f89c00 EBP: c3897bfc ESP: c3897be0
> >  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> > Process modprobe (pid: 2908, ti=c3896000 task=c3935150 task.ti=c3896000)
> > Stack: c01b2afc c2f82d98 c3897bf4 c01ba8b6 c2f86f38 c20b75c8 c2f82c00 c3897c24
> >       c02186dd c2f86f38 c3897c24 c01b54c0 c20b75c8 00000001 c20b75c8 c2f86f38
> >       c20b75c8 c3897c30 c01b54ed 00000001 c3897c54 c01b556c 00000001 c3897cd4
> > Call Trace:
> >  [<c0104cec>] show_trace_log_lvl+0x1a/0x2f
> >  [<c0104d9e>] show_stack_log_lvl+0x9d/0xa5
> >  [<c0104e53>] show_registers+0xad/0x17c
> >  [<c0105017>] die+0xf5/0x1c6
> >  [<c0112715>] do_page_fault+0x450/0x537
> >  [<c02a835a>] error_code+0x6a/0x70
> >  [<c02186dd>] scsi_request_fn+0x5f/0x2ec
> >  [<c01b54ed>] __generic_unplug_device+0x20/0x23
> 
> We jump to a bogus address 0xf88a4a05 via a function pointer from
> scsi_request_fn(). Can you work out the exact file and line for
> scsi_request_fn+0x5f (look for "gdb vmlinux" in
> Documentation/BUG-HUNTING) please?

That'd be Luis' task then :)


-- 
Greetings Michael.
