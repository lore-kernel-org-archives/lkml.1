Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbYJWRZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbYJWRZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbYJWRZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:25:15 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:20444 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbYJWRZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wcXG1UyzsC+VVa5xHxLqBV5NK0f7hF6J6WF7W+Uc1tLX5AHwrxnedQiOmjZoAbASKR
         KXS2yVTxWWyN5QU5kPt6MoOQwVOzsEqwQPDUaB9eDiwe8lU7f32d63VboFOQv5TWs3K8
         m5gL8jWN21mTYbE8OcVCRQzBChoKPpK/uqNSQ=
Message-ID: <c62985530810231025j69c38776q1244510bd7990c6f@mail.gmail.com>
Date: Thu, 23 Oct 2008 19:25:10 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] tracing: fix a build error on alpha and m68k
Cc: "Ingo Molnar" <mingo@elte.hu>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810231311170.1765@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c62985530810230548t1b569f61g34d1900bb94fde83@mail.gmail.com>
	 <c62985530810230757r411b4e3dj4ecec649cf8cf0b3@mail.gmail.com>
	 <Pine.LNX.4.64.0810231727430.18978@anakin>
	 <4900B414.7090002@gmail.com> <20081023163433.GA3160@x200.localdomain>
	 <20081023163850.GB16591@elte.hu>
	 <c62985530810230951u7ae640d5ya45bed466f030074@mail.gmail.com>
	 <20081023165504.GB25697@elte.hu>
	 <c62985530810231006p726bb237qe288ec80b005d8b0@mail.gmail.com>
	 <alpine.DEB.1.10.0810231311170.1765@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Steven Rostedt <rostedt@goodmis.org>:
>
> On Thu, 23 Oct 2008, Fr?d?ric Weisbecker wrote:
>>
>> But to let the core trace.c to be built for other types of tracing,
>> the best thing I see is to put some ifdef CONFIG_TRACE_IRQFLAGS on the
>> tracing_cpumask functions and structure, and actually on the creation
>> of this file.
>
> Is there a reason that you use "raw_local_irq_disable" instead of
> local_irq_disable?


I'm not using anything :)
This is about the tracing_cpumask debugfs file implemented in trace.c
It's tracing_cpumask_write function uses the raw_local functions, I
guess because its locking doesn't need to be traced.
And the problem here is that some archs don't implement raw_local
functions and so trace.c doesn't compile with alpha or m68k.
But actually this file is not needed for them.
