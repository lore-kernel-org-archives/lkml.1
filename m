Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZFEPU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZFEPU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 11:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbZFEPUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 11:20:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZFEPUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 11:20:46 -0400
Message-ID: <4A2937CC.7070503@redhat.com>
Date: Fri, 05 Jun 2009 10:20:44 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Aioanei Rares <krnl.list@gmail.com>, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> <4A293084.5010400@tuffmail.co.uk>
In-Reply-To: <4A293084.5010400@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Aioanei Rares wrote:

>> I suspect, although I might be wrong, that this is not a kernel-related
>> problem.
> 
> "To try and rule out a faulty userspace program, I marked the file as 
> read-only (chmod a-w) and immutable (chattr +i).  After a reboot, the 
> file was still read-only and immutable, yet it still became corrupted."
> 
> Since the immutable bit is not respected, I tend to think it is a kernel 
> problem.  Unless the filesystem isn't getting unmounted/flushed properly 
> for some reason... but I thought the modern kernel had that covered.
> 
> I agree it is very suspicious this happens only after upgrading libc.  
> I'll see if I can find an individual change in libc locale-handling that 
> might trigger this.

Maybe you could try some things in your shutdown script, such as
explicitly fsyncing the file, or bmapping it with filefrag, or dropping
caches and rereading it... see what the state is just before the
shutdown compared to after the reboot.

-Eric
