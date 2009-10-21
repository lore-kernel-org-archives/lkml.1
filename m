Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbZJUQqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbZJUQqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbZJUQqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:46:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbZJUQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:46:05 -0400
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
 MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: David Daney <ddaney@caviumnetworks.com>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <4ADF38D5.9060100@caviumnetworks.com>
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
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 21 Oct 2009 12:46:08 -0400
Message-Id: <1256143568.18347.3169.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-21 at 09:37 -0700, David Daney wrote:

> There is no deterministic way to identify MIPS function prologs.  This 
> is especially true for leaf functions, but also for functions with 
> multiple return sites.
> 
> For certain GCC versions there may be a set of command line options that 
> would give good results, but in general it is not possible.  Attempts at 
> fast backtrace generation using code inspection are not reliable and 
> will invariably result in faults and panics when they fail.

Thanks for the update.

We can easily protect against panics, since we do fault protection
within the code (although currently it will panic on fault, but we can
fix that ;-). We can limit the search to a couple of 100 instructions,
as well as fail on first panic.

But are you sure that when compiled with -pg, that GCC does not give a
reliable prologue. Things are different when GCC is compiled with -pg,
it may indeed always have something that we can flag.

We could also add other tests, like the subtraction of the stack too.

-- Steve


