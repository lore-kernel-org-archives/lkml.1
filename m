Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZJVPU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZJVPU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbZJVPUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:20:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208AbZJVPUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:20:19 -0400
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: wuzhangjin@gmail.com
Cc: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <1256218263.3852.115.camel@falcon>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <96110ea5dd4d3d54eb97d0bb708a5bd81c7a50b5.1256135456.git.wuzhangjin@gmail.com>
	 <5dda13e8e3a9c9dba4bb7179183941bda502604f.1256135456.git.wuzhangjin@gmail.com>
	 <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com>
	 <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com>
	 <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com>
	 <1256141540.18347.3118.camel@gandalf.stny.rr.com>
	 <4ADF38D5.9060100@caviumnetworks.com>
	 <1256143568.18347.3169.camel@gandalf.stny.rr.com>
	 <4ADF3FE0.5090104@caviumnetworks.com>
	 <1256145813.18347.3210.camel@gandalf.stny.rr.com>
	 <1256211516.3852.47.camel@falcon>
	 <1256217444.20866.599.camel@gandalf.stny.rr.com>
	 <1256218263.3852.115.camel@falcon>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 22 Oct 2009 11:20:22 -0400
Message-Id: <1256224822.20866.728.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 21:31 +0800, Wu Zhangjin wrote:

> > If we don't stop at just one save, but look for the saving of ra, it
> > should not fail.
> > 
> 
> We can not look for the saving of ra continuously(when should we stop?

When we hit something other than sw .... I'm sure we will get to
something other than a store. ;-)

> if with -fno-omit-fram-pointer, we have "move s8,sp" or "addiu sp, sp,
> -offset", but without it, we have no "guideboard" to know that is the
> beginning of the function!), 'Cause we may find the saving of ra of
> another function, which will fail at that time.

But that other function should have a jump to mcount before it, or some
other kind of return. A function that has _mcount attached, can not be
inlined. So something must have jumped to it. There should be no cases
where code from above just "falls" into the leaf function.

> 
> BTW: Just replace probe_kernel_read() and tracing_stop/tracing_start by
> asm, it works in 32bit, but fails in 64bit, I'm trying to find why!(TLB
> miss on load or ifetch, will fix it asap! and resend the patchset out!)

Thanks!

-- Steve

Note, I'm going to try booting a vanilla kernel on the notebook. If it
works, I'll start applying your patches and playing with it too. But I
also have some other work to do first.



