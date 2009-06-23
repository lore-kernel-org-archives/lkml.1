Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZFWAeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZFWAeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbZFWAdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:33:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35998 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZFWAdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:33:53 -0400
Message-ID: <4A4022EA.1020506@jp.fujitsu.com>
Date: Tue, 23 Jun 2009 09:33:46 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Subject: Re: [PATCH 1/7] ia64, kdump: Mask MCA/INIT on freezing cpus
References: <4A39E247.4030908@jp.fujitsu.com> <4A39E2CF.80901@jp.fujitsu.com> <20090622134557.GC7084@sgi.com>
In-Reply-To: <20090622134557.GC7084@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
>> To avoid this problem, This patch inserts ia64_set_psr_mc() before the
>> deadloop to mask MCA/INIT on cpus going to be frozen.  I confirmed that
>> weird log like above are disappeared after applying this patch.
> 
> Please do not do this.  Turning off MCA/INIT is just a horrible idea.
> When your code has a bug, the INIT of the cpu is the only tool we have
> to find out what it is doing short of putting special hardware onto the
> machine and trying to track it down.

This patch never mask MCA/INIT while the system is running normally.
The first place I inserted the masking is just after panic, and just after
INIT is asserted.  This patch doesn't prevent you from taking kdump or
stack trace on your machine.

Maybe I could not catch what you pointed.
One of the problems I'm targeting here is that there is no way to allow
INIT while kernel transition.  What are you expecting with INIT if it is
asserted on the beginning of the 2nd kernel?

And note that this patch 1 of 7 is necessary to run the INIT handler of
the 2nd kernel, which might be registered by the 2nd kernel.

> Without thinking about it, I have a gut feeling there must be some way
> to at least allow the MCA/INIT to make it through PROM and be delivered
> to the OS.  From there the OS should be able to sort out a way to handle
> kdump and MCAs received during a kdump.

Do you mean that the 2nd kernel should be able to handle MCA/INIT from its
boot up?  I guess the word PROM is nearly equal to PAL/SAL firmware, if so
then I don't think there are good generic interface/procedure could be
useful here.  Do you have any concrete idea?


Thanks,
H.Seto

