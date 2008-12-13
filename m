Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbYLMPWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbYLMPWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 10:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYLMPW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 10:22:27 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:14160 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYLMPW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 10:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YHEV6gMmj+g2MzPAx7JOo+BTl9aDLlgJkctQeGVteEy4Rel5BxXx7mcDND6odbgP4z
         +oZGUhQVvXqbIMb4+jEaZqSLxuBdYjFKBtLNdBgcLMJBXqCTqXtrxPg8gXTykKsX6rVx
         22K44mwXvCwhjXLP+LGtIcN8F6RAiDCUpdmkU=
Message-ID: <c62985530812130722u5a4fbfcayd8c61dadbc5b1792@mail.gmail.com>
Date: Sat, 13 Dec 2008 16:22:25 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/3] tracing/function-graph-tracer: signal interrupt triggering on output
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081213074930.GA4205@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <493EF64D.50804@gmail.com> <493EF797.7090603@gmail.com>
	 <20081212101448.GE18152@elte.hu>
	 <c62985530812120327l369abf7eud17e2a06c7d2bd12@mail.gmail.com>
	 <20081213074930.GA4205@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/13 Ingo Molnar <mingo@elte.hu>:
> Another thing, i just noticed that ftrace_print() is broken in certain
> situations, for example a plain newline:
>
>        ftrace_printk("\n");
>
> printed via trace_pipe will print some weirdly concatenated line:
>
>           <...>-2994  [007]   406.498986: debug_show:          <...>-2994  [007]   406.498986:            <...>-2994  [007]   406.498986: debug_show:
>
> not via a separate, standalone, empty line.

I just tested with latest -tip and I don't any problem with it.
With a single ftrace_printk("\n") on might_sleep() I get:

           <...>-2739  [000]   145.692153: __might_sleep:
           <...>-2739  [000]   145.692155: __might_sleep:
           <...>-2739  [000]   145.692157: __might_sleep:
           <...>-2739  [000]   145.692158: __might_sleep:

with trace or trace_iter file.
Does it always occur or in rare situations?
