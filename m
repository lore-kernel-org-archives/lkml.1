Return-Path: <linux-kernel-owner+w=401wt.eu-S1764441AbYEBJG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764441AbYEBJG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758389AbYEBJGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:06:20 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:29374 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852AbYEBJGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:06:19 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86: 8K stacks by default
From: Andi Kleen <andi@firstfloor.org>
References: <200805010359.m413xWBV014593@hera.kernel.org>
	<20080501101956.695c5b34@core> <20080502071542.GA713@elte.hu>
Date: Fri, 02 May 2008 11:05:16 +0200
In-Reply-To: <20080502071542.GA713@elte.hu> (Ingo Molnar's message of "Fri, 2 May 2008 09:15:42 +0200")
Message-ID: <87wsmdf54j.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 08:58:22.0545 (UTC) FILETIME=[ACAD7410:01C8AC32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
>
> The plan is to remove "this overflows my stack here and now" technical 
> argument: we'll add the stack-footprint measurement tracing plugin from 
> -rt to ftrace and get that upstream. In -rt's tracer we can measure, 
> track and trace the exact worst-case stack footprint of a system, since 
> bootup. It relies on the function tracer which looks at the current 
> stack footprint at every given moment. It's not a statistical sample, it 
> tracks the true worst-case stack footprint.

I had such a measurement patch a long time ago for 2.4 x86-64
(ftp://ftp.x86-64.org/pub/linux-x86_64/debug/stackcheck-1)

But the problem today is the same as it was back then: you can't
really get the production users with the nasty workloads who actually
trigger the difficult overflows to run something like this which has
quite high runtime overhead.

> _Then_ there can be no real technical argument about making the more 
> robust 4K stacks the default.

You typoed: s/more/less/

-Andi

P.S. I agree with Alan that the interrupt stacks should be always enabled even 
with 8k stacks.
