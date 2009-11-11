Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbZKKCmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbZKKCmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbZKKCmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:42:43 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:48357 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724AbZKKCmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:42:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Kwr7UZRpU4UaYoI0jPthy5DM4kHUs0QBX8/6XBUim1YxbzpMBeefpYlfJbZvjbH6fX
         u0tO9vEfcE37tY2mJMcQeRvZ14H+smfghH5LoH6LISfGY9H/0qxm0LgZqqMUXn+As4gt
         EwYXZm3jBV1Cyh+aXLSVHFBj4udU4i8/YvhSQ=
Subject: Re: [PATCH v7 04/17] tracing: add static function tracer support
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: David Daney <ddaney@caviumnetworks.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       zhangfx@lemote.com, zhouqg@gmail.com,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
In-Reply-To: <4AF99848.9090000@caviumnetworks.com>
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com>
	 <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com>
	 <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
	 <cefe074f5eb3cfbc2e0bb41b0c1f61fcd0190d90.1257779502.git.wuzhangjin@gmail.com>
	 <4AF8B31C.5030802@caviumnetworks.com>
	 <1257814817.2822.3.camel@falcon.domain.org>
	 <4AF99848.9090000@caviumnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Wed, 11 Nov 2009 10:42:31 +0800
Message-ID: <1257907351.2922.37.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2009-11-10 at 08:43 -0800, David Daney wrote:
[...]
> >>> +ifndef CONFIG_FUNCTION_TRACER
> >>>  cflags-y := -ffunction-sections
> >>> +else
> >>> +cflags-y := -mlong-calls
> >>> +endif
> >>>  cflags-y += $(call cc-option, -mno-check-zero-division)
> >>>  
> >> That doesn't make sense to me.  Modules are already compiled with 
> >> -mlong-calls.  The only time you would need the entire kernel compiled 
> >> with -mlong-calls is if the tracer were in a module.  The logic here 
> >> doesn't seem to reflect that.
> > 
> > Yes, I knew the module have gotten the -mlong-calls, Here we just want
> > to use -mlong-calls for the whole kernel, and then we get the same
> > _mcount stuff in the whole kernel, at last, we can use the same
> > scripts/recordmcount.pl and ftrace_make_nop & ftrace_make_call for the
> > dynamic ftracer.
> > 
> 
> -mlong-calls really degrades performance.  I have seen things like 6% 
> drop in network packet forwarding rates with -mlong-calls.
> 

so much drop? seems only two instructions added for it: lui, addi. from
this view point, I think the -fno-omit-frame-pointer(add, sd, move...)
will also bring with much drop.

It's time to remove them? -mlong-calls, -fno-omit-frame-pointer.

> It would be better to fix all the tools so that they could handle both 
> -mlong-calls and -mno-long-calls code.
> 

It's totally possible, will try to make it work later. I just wanted the
stuff simple, but if it really brings us with much drop, it's time to
fix it.

Regards,
	Wu Zhangjin

