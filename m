Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYKUNOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYKUNOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYKUNOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:14:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYKUNOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:14:21 -0500
Date: Fri, 21 Nov 2008 08:14:18 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Liming Wang <liming.wang@windriver.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] function tracing: fix wrong position computing of
 stack_trace
In-Reply-To: <1227236418-6023-2-git-send-email-liming.wang@windriver.com>
Message-ID: <alpine.DEB.1.10.0811210813510.6447@gandalf.stny.rr.com>
References: <1227236418-6023-1-git-send-email-liming.wang@windriver.com> <1227236418-6023-2-git-send-email-liming.wang@windriver.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Nov 2008, Liming Wang wrote:

> Impact: make output of stack_trace complete if buffer overflow
> 
> When read buffer overflows, the output of stack_trace isn't complete.
> 
> When printing records with seq_printf in t_show, if the read buffer
> has overflowed by the current record, then this record won't be printed
> to user space through read buffer, it will just be dropped in this printing.
> 
> When next printing, t_start should return the "*pos"th record, which is the one
> dropped by previous printing, but it just returns (m->private + *pos)th record.
> 
> Here we use a more sane method to implement seq_operations which can be found
> in kernel code. Thus we needn't initialize m->private.
> 
> About testing, it's not easy to overflow read buffer, but we can use
> seq_printf to print more padding bytes in t_show, then it's easy to check
> whether or not records are lost.
> 
> This commit has been tested on both condition of overflow and non overflow.
> 
> Signed-off-by: Liming Wang <liming.wang@windriver.com>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

