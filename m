Return-Path: <linux-kernel-owner+w=401wt.eu-S932989AbXAWMTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbXAWMTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 07:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXAWMTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 07:19:08 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:38781 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932989AbXAWMTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 07:19:07 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Luigi Genoni" <luigi.genoni@pirelli.com>
Cc: <akpm@osdl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: System crash after "No irq handler for vector" linux 2.6.19
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1ps973rxh.fsf@ebiederm.dsl.xmission.com>
	<200701231051.32945.luigi.genoni@pirelli.com>
Date: Tue, 23 Jan 2007 05:18:40 -0700
In-Reply-To: <200701231051.32945.luigi.genoni@pirelli.com> (Luigi Genoni's
	message of "Tue, 23 Jan 2007 10:51:32 +0100")
Message-ID: <m1y7nu2axr.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Luigi Genoni" <luigi.genoni@pirelli.com> writes:

> reproduced.
> it took more or less one hour to reproduce it.  I could reproduce it olny 
> running also irqbalance 0.55 and commenting out the sleep 1. The message in 
> syslog is the same and then, after a few seconds I think, KABOM! system crash 
> and reboot.
>
> I tested also a similar system that has 4 dual core CPU Opteron 2600MHZ. On 
> this system (linux sees 8 CPU, but it is the same kernel, same gcc, same 
> config, same glibc, same active services) I could not reproduce it even 
> running irqbalance 0.55 in almost 1 hour. Maybe I could reproduce it waiting 
> for more time, but my users need to do their work, so I could not have a 
> longer test window. So on 16 CPU I had the crash, on 8 CPU I had no crash. 
>
> I need to give back the system to the users, so if you need other tests, 
> please, tell me as soon.

Ok.  Since it seems to be the irq code I'm going to need to get a dump
of the state of the apics, basically the output print_IO_APIC from the time
this happens. 

I'm not really out of bed yet so no patch but a heads up.  Once I've finished
sleeping I'll look at putting a debugging patch together.

Getting a bootlog of the identical system that would not crash at 8 cpus
would be interesting.  In part this is because the number of apic modes
that are available for use are much fewer when we have 8 or more cpus,
so it would be interesting to see if it is actually using the same code
for interrupt delivery.

If you have a few minutes to try it, it would be interesting to know
if forcing the migration from the command line (as I was suggesting)
would reproduce this faster than irqbalance.

Hopefully I can think up things to fix this when I wake up.

The time zone difference is going to be a pain :(

Eric
