Return-Path: <linux-kernel-owner+w=401wt.eu-S1755187AbYLJIrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187AbYLJIrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 03:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbYLJIqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 03:46:54 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:54850 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbYLJIqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 03:46:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OEP9C1+u8T3YHpiwVqlyOSyZnYr3PYNJYTlu6IcPYr3yPsv+E1ykA4I9cmD0akrBMV
         8/qxM2vgUVBBs0rF2rEDxVt39UiPfxX3IYfrakdEZsGSYvGJ/EbGKzD3sNGt4CoeZNSk
         4gecgK0PfxAsFIVxE/3uBd2of0tq5oekfnp2E=
Message-ID: <c62985530812100046l69ca7019j545fed604c373efa@mail.gmail.com>
Date: Wed, 10 Dec 2008 09:46:51 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt triggering on output
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812092111510.19875@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493EF64D.50804@gmail.com>
	 <alpine.DEB.1.10.0812092111510.19875@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/10 Steven Rostedt <rostedt@goodmis.org>:
>
> On Tue, 9 Dec 2008, Frederic Weisbecker wrote:
>
>> This patchset adds all the features to draw hardirq triggering on output
>> for the function graph tracer.
>> An example is given on the third patch.
>>
>> Just one question, on recordmcount.pl:
>>
>> my %text_sections = (
>>       ".text" => 1,
>>       ".sched.text" => 1,
>>       ".spinlock.text" => 1,
>>
>> The .sched.text section is included inside .text, it's a subsection, I'm not sure
>> it's necessary to add it in text_sections. In doubt I added the new .irqentry.text
>>
>
> Matters what objdump -dr shows.
>
> $ objdump -dr kernel/sched.o | grep 'Disassembly'
> Disassembly of section .text:
> Disassembly of section .cpuinit.text:
> Disassembly of section .init.text:
> Disassembly of section .sched.text:
>
> Yep, .sched.text is needed.  It is not about what gets linked by the
> linker. It is about what objdump shows, which is what recordmcount.pl uses
> to determine whether or not to record the mcount callers in that section.


Ok. I looked at a disassembly objdump on vmlinux to find those
subsections and didn't find it.
But I didn't see that recordmcount did its work on each build folder,
I guess that these sections are
visible on the objects found in the subdirectories....

Thanks.
