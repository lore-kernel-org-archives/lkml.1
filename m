Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbZJZAgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbZJZAgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 20:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZJZAgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 20:36:25 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:43114 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbZJZAgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 20:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hu/WN6zuSz9sJGNYAj8BoZqXil4cDp6hrjQiwyi0LmAddAAMzoRwBCbuzKOKBzhE5l
         SZ3uIoUvUtR77s6UD1FLrCu8IZmU/gthr+3AwB304+9QcHEbzzBSoynKbP+mXz3GwjMm
         ykQTE/aqk494mT+Yv+CWLSTsptBIRXqeFna44=
MIME-Version: 1.0
In-Reply-To: <6ad82af0c2ec8ef7b9f536b0a97bf65d385c3945.1256483735.git.wuzhangjin@gmail.com>
References: <cover.1256482555.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256483735.git.wuzhangjin@gmail.com>
	 <3e0c2d7d8b8f196a8153beb41ea7f3cbf42b3d84.1256483735.git.wuzhangjin@gmail.com>
	 <54c417629e91f40b2bbb4e08cda2a4e6527824c0.1256483735.git.wuzhangjin@gmail.com>
	 <29bccff04932e993ecd9f516d8b6dcf84e2ceecf.1256483735.git.wuzhangjin@gmail.com>
	 <72f2270f7b6e01ca7a4cdf4ac8c21778e5d9652f.1256483735.git.wuzhangjin@gmail.com>
	 <6140dd8f4e1783e5ac30977cf008bb98e4698322.1256483735.git.wuzhangjin@gmail.com>
	 <cover.1256483735.git.wuzhangjin@gmail.com>
	 <49b3c441a57f4db423732f81432a3450ccb3240e.1256483735.git.wuzhangjin@gmail.com>
	 <6ad82af0c2ec8ef7b9f536b0a97bf65d385c3945.1256483735.git.wuzhangjin@gmail.com>
Date: Mon, 26 Oct 2009 01:36:28 +0100
Message-ID: <c62985530910251736ye7551c4l1a62a1ba242a191f@mail.gmail.com>
Subject: Re: [PATCH -v5 09/11] tracing: add IRQENTRY_EXIT for MIPS
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       Adam Nemet <anemet@caviumnetworks.com>,
       Patrik Kluba <kpajko79@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/25 Wu Zhangjin <wuzhangjin@gmail.com>:
> This patch fix the following error with FUNCTION_GRAPH_TRACER=y:
>
> kernel/built-in.o: In function `print_graph_irq':
> trace_functions_graph.c:(.text+0x6dba0): undefined reference to `__irqentry_text_start'
> trace_functions_graph.c:(.text+0x6dba8): undefined reference to `__irqentry_text_start'
> trace_functions_graph.c:(.text+0x6dbd0): undefined reference to `__irqentry_text_end'
> trace_functions_graph.c:(.text+0x6dbd4): undefined reference to `__irqentry_text_end'
>
> (This patch is need to support function graph tracer of MIPS)


If you want to enjoy this section, you'd need to tag the
mips irq entry functions with "__irq_entry"  :)

I guess there is a do_IRQ() in mips that is waiting for that (and
probably some others).
The effect is that interrupt areas are cut with a pair of arrows
in the trace, so that you more easily spot interrupts in the traces

May be I missed this part in another patch in this series though...
