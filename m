Return-Path: <linux-kernel-owner+w=401wt.eu-S1752783AbYLXDdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbYLXDdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 22:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbYLXDdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 22:33:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53970 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbYLXDdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 22:33:23 -0500
Date: Tue, 23 Dec 2008 22:33:21 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] tracing/ftrace: don't trace on early stage of
 secondary cpu boot
In-Reply-To: <c62985530812231844w7bdc493secbbeaf4372afa52@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0812232231140.21172@gandalf.stny.rr.com>
References: <49518535.8080105@gmail.com>  <alpine.DEB.1.10.0812232106080.6972@gandalf.stny.rr.com> <c62985530812231844w7bdc493secbbeaf4372afa52@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Dec 2008, Fr?d?ric Weisbecker wrote:
> 
> 
> I first thought about annotate those first functions with "notrace".
> But the code inside
> cpu_init/pda_init could change later and call external/traced function.

We could also hit it with the CFLAGS_REMOVE_common.o = -pg hammer.
Those functions will not change much, and I doubt they will call other 
functions for the same reason that we can not call them. A simple 
preempt_disable here will crash the box.

-- Steve

