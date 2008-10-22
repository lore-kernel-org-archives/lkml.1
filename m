Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYJVHFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYJVHFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYJVHFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:05:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49087 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYJVHFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:05:06 -0400
Subject: Re: [PATCH] lockstat: contend with points
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Pepper <tpepper@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?T=F6r=F6k?= Edwin <edwintorok@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
In-Reply-To: <eada2a070810211559u6a040d29y11d1235557ac44f3@mail.gmail.com>
References: <1224231505.28131.71.camel@twins>
	 <eada2a070810211559u6a040d29y11d1235557ac44f3@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Oct 2008 09:04:56 +0200
Message-Id: <1224659096.6724.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 15:59 -0700, Tim Pepper wrote:
> On Fri, Oct 17, 2008 at 1:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > +06                          &mm->mmap_sem-W:           233            538 18446744073708       22924.27      607243.51           1342          45806           1.71        8595.89     1180582.34
> > +07                          &mm->mmap_sem-R:           205            587 18446744073708       28403.36      731975.00           1940         412426           0.58      187825.45     6307502.88
> > +08                          ---------------
> > +09                            &mm->mmap_sem            487          [<ffffffff8053491f>] do_page_fault+0x466/0x928
> > +10                            &mm->mmap_sem            179          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
> > +11                            &mm->mmap_sem            279          [<ffffffff80210a57>] sys_mmap+0x75/0xce
> > +12                            &mm->mmap_sem             76          [<ffffffff802a490b>] sys_munmap+0x32/0x59
> > +13                          ---------------
> > +14                            &mm->mmap_sem            270          [<ffffffff80210a57>] sys_mmap+0x75/0xce
> > +15                            &mm->mmap_sem            431          [<ffffffff8053491f>] do_page_fault+0x466/0x928
> > +16                            &mm->mmap_sem            138          [<ffffffff802a490b>] sys_munmap+0x32/0x59
> > +17                            &mm->mmap_sem            145          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
> > +18
> > +19 ...............................................................................................................................................................................................
> > +20
> > +21                              dcache_lock:           621            623           0.52         118.26        1053.02           6745          91930           0.29         316.29      118423.41
> > +22                              -----------
> > +23                              dcache_lock            179          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
> > +24                              dcache_lock            113          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
> > +25                              dcache_lock             99          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
> > +26                              dcache_lock            104          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a
> > +27                              -----------
> > +28                              dcache_lock            192          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
> > +29                              dcache_lock             98          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
> > +30                              dcache_lock             72          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
> > +31                              dcache_lock            112          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a
> 
> 
> 
> Just out of curiousity...what was running as you collected these?

I think I just booted the machine, didn't run anything much.
