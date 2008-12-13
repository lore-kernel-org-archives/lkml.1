Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYLMPQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYLMPQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 10:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYLMPQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 10:16:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:18320 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbYLMPQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 10:16:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=eyBIHxEYlKVCxz2RH++AC6p1NSdrwZ8RBpE6hRB7ZBRxXVvOYsaAW70/VgPR6JpdiG
         ztFCQNZuW15Q2bP8jKJqRURQlbbq4d/sC7i9Kz/C4d+uY7VIp0XRfdOhudeYCiAXSRB1
         oHbYiDPylxNlkowNmMiToInRTb1qyIdg5q2os=
Date: Sat, 13 Dec 2008 18:16:00 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Message-ID: <20081213151600.GA12556@localhost>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain> <20081212204724.GA26194@localhost> <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com> <20081212205729.GA28554@localhost> <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com> <20081212213538.GA731@localhost> <alpine.DEB.1.10.0812121655090.19351@gandalf.stny.rr.com> <20081213082054.GA7559@localhost> <c62985530812130646r6bcdf424o752f16458dd22914@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530812130646r6bcdf424o752f16458dd22914@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Frédéric Weisbecker - Sat, Dec 13, 2008 at 03:46:03PM +0100]
| 2008/12/13 Cyrill Gorcunov <gorcunov@gmail.com>:
| > [Steven Rostedt - Fri, Dec 12, 2008 at 04:56:47PM -0500]
| > ...
| > | > Steve, here is how it could look like:
| > | > (I liked first proposal more :)
| > |
| > | I see the confusion. In ftrace.h the function graph tracer config is not
| > | inside CONFIG_FUNCTION_TRACER, even though it is dependent on it (or
| > | was). OK, just do your first proposal then.
| > |
| > | -- Steve
| > |
| >
| > ok, I sent it yesterday as
| >
| >        http://lkml.org/lkml/2008/12/12/301
| >        [PATCH] x86: entry_64 - introduce FTRACE_ frame macro v2
| >
| > Ingo, will you pick it up?
| >
| >                - Cyrill -
| >
| 
| Hi,
| 
| Looks good and clarify the asm bits.
| 
| I wonder if the function_graph_tracer should continue to necessarily
| depend on the function tracer.
| It was more simplier to do so but perhaps that could be avoided with
| small modifications.
| 

Hi Frédéric,

I didn't play with tracer internals since was more concerned about
asm part of code. If you find that we better should introduce
additional deps here or change a "deps graph" itself - I think it
will be easy to place a new patch on top of this (or replace my
patch) :)

The only thing I would change in mine patch is -- subq/addq $0x38, %rsp
since the following code uses decimal system but not a big deal anyway.

		- Cyrill -
