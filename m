Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbYJWRi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbYJWRi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbYJWRil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:38:41 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:29281 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbYJWRik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=g/+2S6Ka2+NsNN8YlPI/vSjE44I5CDA/k7Rqd26S2EwPX/BgDL6mR+I36EM7Aqqv20
         t++9L2DJIDB1LvSkBLoFDoWWBQGwwqyPY8BVVh6CDnPFq0cAETmlJRyLjCP/QcLvZb37
         uTFQjYE9K+0f2Y8OJUjUYyyjJ8bm7sbZLK6eI=
Message-ID: <c62985530810230951u7ae640d5ya45bed466f030074@mail.gmail.com>
Date: Thu, 23 Oct 2008 18:51:35 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20081023163850.GB16591@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081023213637.eff9b414.sfr@canb.auug.org.au>
	 <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
	 <c62985530810230615s3252a54ao6488e763d72dc939@mail.gmail.com>
	 <49008D12.5090204@gmail.com>
	 <Pine.LNX.4.64.0810231635440.18978@anakin>
	 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
	 <Pine.LNX.4.64.0810231727430.18978@anakin>
	 <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain>
	 <20081023163850.GB16591@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Ingo Molnar <mingo@elte.hu>:
> hm, zapped the commit then.
>
> the problem is most likely that none of these architectures is lockdep
> enabled, hence they have no irqtrace wrappers, hence not all of the
> tracers can be built on them?
>
>        Ingo
>

But they should be able to use the tracing for several other tracers.
One other problem is that you need CONFIG_TRACE_IRQFLAGS (is that a
lockdep or just trace feature?) to use any tracer since the
tracing_cpumask file is always created for all tracer. This file has
tracing_cpumask_write() as a write operation, and this func uses
raw_local_funcs....

Perhaps we should disable the tracing_cpu_mask related things if
TRACE_IRQFLAGS in not configured?
