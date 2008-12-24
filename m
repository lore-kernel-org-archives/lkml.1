Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbYLXDMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbYLXDMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:12:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYLXDL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:11:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48108 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYLXDLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:11:55 -0500
Date: Tue, 23 Dec 2008 22:11:54 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/ftrace: don't trace on early stage of
 secondary cpu boot
In-Reply-To: <c62985530812231857l17362f94k271b66abbe7d7099@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812232210380.20511@gandalf.stny.rr.com>
References: <49518535.8080105@gmail.com>  <alpine.DEB.1.10.0812232106080.6972@gandalf.stny.rr.com> <c62985530812231857l17362f94k271b66abbe7d7099@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Dec 2008, Fr?d?ric Weisbecker wrote:
> 
> One other solution, would be to define raw_smp_processor_id() to
> stack_smp_processor_id() and current to
> cpu_pda(stack_smp_processor_id()) if function_tracer is configured.
> That would even let one to trace those cpu boot
> functions.
> 
> But the other side effect with this is that perhaps "current" would be
> retrieved with one pointer more to dereference....

Nah, I think that is a bit too intrusive. We really do not want to call 
the function tracer if it can not handle a simple smp_processor_id() call. 
You never know what else might turn up in this area.

-- Steve

