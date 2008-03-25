Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYCYRR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYCYRR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 13:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbYCYRRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 13:17:20 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:43606 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbYCYRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 13:17:19 -0400
To: Luciano Rocha <luciano@eurotux.com>
Cc: Michael Meyer <mike65134@yahoo.de>, linux-kernel@vger.kernel.org
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
References: <16336.23884.qm@web25814.mail.ukl.yahoo.com>
	<20080325140825.GA19722@bit.office.eurotux.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Mar 2008 18:16:47 +0100
In-Reply-To: <20080325140825.GA19722@bit.office.eurotux.com>
Message-ID: <87abkmhgg0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2008 17:10:10.0240 (UTC) FILETIME=[14EFE400:01C88E9B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luciano Rocha <luciano@eurotux.com> writes:

> On Tue, Mar 25, 2008 at 02:47:50PM +0100, Michael Meyer wrote:
> > Hi, 
> > 
> > what is the difference between booting a dual core
> > machine with "maxcpus=1" or by deactivating the second
> > core at run time with "echo 0 >
> > /sys/devices/system/cpu/cpu1/online"?
> 
> maxcpus=1 should turn off the SMP alternative and switch to UP only,
> optimising some locks and instructions.

CPU hot unplug will do the same. But it is unlikely it accounts
for that much performance difference.

If he used maxcpus=0 it would make sense. maxcpus=0 disables
the IO-APIC which likely makes a large difference. But it should
be actually slower.

There should be actually no difference in theory between max_cpus=1
and hot unplug to one CPU. Might be some bug.

-Andi
