Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZKIEbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZKIEbO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 23:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbZKIEbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 23:31:13 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51890 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZKIEbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 23:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=KZOCoXJKzjS/BkWIQx2FkoRPdr1l9RGVWlpKKd55YEbQtMMRs7xaqG49nig0shxONy
         podjKHX7xvqG+ZaXMcu6JSRGN3k+9WPVvcniQKw/eobpvqqn4VfrjzxaWVIw6hBVN4dq
         Dv1oYPtrfwSxB2xyPci/V1+xLK1/1B+3v9CB4=
Subject: Re: [PATCH -v5 08/11] tracing: not trace mips_timecounter_init()
 in MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
In-Reply-To: <20091102214351.GI4880@nowhere>
References: <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com>
	 <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com>
	 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
	 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
	 <cover.1256483735.git.wuzhangjin@gmail.com>
	 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
	 <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
	 <c62985530910251727o23beafcco539870e4b2f84637@mail.gmail.com>
	 <1256550156.5642.148.camel@falcon>  <20091102214351.GI4880@nowhere>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Mon, 09 Nov 2009 12:31:12 +0800
Message-ID: <1257741072.3451.27.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-11-02 at 22:43 +0100, Frederic Weisbecker wrote:
[...]
> > > 
> > > But I would rather see a __mips_notrace on these two core functions.
> > 
> > What about this: __arch_notrace? If the arch need this, define it,
> > otherwise, ignore it! if only graph tracer need it, define it in "#ifdef
> > CONFIG_FUNCTION_GRAPH_TRACER ... #endif".
> 
> 
> 
> The problem is that archs may want to disable tracing on different
> places.
> For example mips wants to disable tracing in timecounter_read_delta,
> but another arch may want to disable tracing somewhere else.
> 
> We'll then have several unrelated __arch_notrace. One that is relevant
> for mips, another that is relevant for arch_foo, but all of them will
> apply for all arch that have defined a __arch_notrace.
> 
> It's true that __mips_notrace is not very elegant as it looks like
> a specific arch annotation intruder.
> 
>
> But at least that gives us a per arch filter granularity.
> 
> If only static ftrace could disappear, we could keep only dynamic
> ftrace and we would then be able to filter dynamically.
> But I'm not sure it's a good idea for archs integration.
> 

I think if we use something like __mips_notrace here, we may get lots of
__ARCH_notraces here too, 'Cause some other platforms(at least, as I
know, Microblaze will do it too) may also need to add one here, it will
become:

__mips_notrace __ARCH1_notrace __ARCH2_notrace .... foo() {...}

A little ugly ;)

and If a new platform need it's __ARCH_notrace, they need to touch the
common part of ftrace, more side-effects!

but with __arch_notrace, the archs only need to touch it's own part,
Although there is a side-effect as you mentioned above ;)

So, what should we do?

Regards,
	Wu Zhangjin

