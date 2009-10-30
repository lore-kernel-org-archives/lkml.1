Return-Path: <linux-kernel-owner+w=401wt.eu-S932607AbZJ3T67@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbZJ3T67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:58:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932223AbZJ3T66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:58:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbZJ3T65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:58:57 -0400
Subject: Re: [patch 3/3] x86_64, cpa: use only text section in
 set_kernel_text_rw/ro
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1256930228.2679.5.camel@sbs-t61.sc.intel.com>
References: <20091029024820.996634347@sbs-t61.sc.intel.com>
	 <20091029024821.164525222@sbs-t61.sc.intel.com>
	 <1256781977.26028.2139.camel@gandalf.stny.rr.com>
	 <1256930228.2679.5.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 30 Oct 2009 15:59:00 -0400
Message-Id: <1256932740.26028.3310.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-30 at 11:17 -0800, Suresh Siddha wrote:
> On Wed, 2009-10-28 at 19:06 -0700, Steven Rostedt wrote:
> > On Wed, 2009-10-28 at 18:46 -0800, Suresh Siddha wrote:
> > > plain text document attachment (fix_kernel_text_ro_rw.patch)
> > > set_kernel_text_rw()/set_kernel_text_ro() are marking pages starting
> > > from _text to __start_rodata as RW or RO.
> > > 
> > > With CONFIG_DEBUG_RODATA, there might be free pages (associated with
> > > padding the sections to 2MB large page boundary) between text
> > > and rodata sections that are given back to page allocator. So we should
> > > use only use the start (__text) and end (__stop___ex_table) of the
> > > text section in set_kernel_text_rw()/set_kernel_text_ro().
> > > 
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > > ---
> > >  
> > 
> > I'll go ahead and test this to make sure it does not bust ftrace with an
> > allyesconfig.
> 
> Steve, Good to go?

Yep. Sorry, during the testing I hit the jprobe vs function graph bug
and got distracted. But as for this patch set ...

Tested-by: Steven Rostedt <rostedt@goodmis.org>

Thanks,

-- Steve

> 
> If so, Ingo can you please consider this patchset?


