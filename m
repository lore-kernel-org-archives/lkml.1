Return-Path: <linux-kernel-owner+w=401wt.eu-S933528AbXBXSIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528AbXBXSIY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 13:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933530AbXBXSIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 13:08:24 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:42760 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933528AbXBXSIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 13:08:23 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: Daniel Walker <dwalker@mvista.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: mbligh@google.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
In-Reply-To: <20070224161906.GA9497@Krystal>
References: <20061124215904.GI25048@Krystal>
	 <1164475747.5196.5.camel@localhost.localdomain>
	 <20061126170542.GA30771@Krystal>
	 <1164561427.16871.14.camel@localhost.localdomain>
	 <20061126231833.GA22241@Krystal>
	 <1164585589.16871.52.camel@localhost.localdomain>
	 <20070224161906.GA9497@Krystal>
Content-Type: text/plain
Date: Sat, 24 Feb 2007 10:06:09 -0800
Message-Id: <1172340369.24216.31.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-24 at 11:19 -0500, Mathieu Desnoyers wrote:
> Hi,
> 
> I am trying to improve the Linux kernel time source so it can be read
> without seqlock from NMI handlers. I have also seen some interest for
> such an accurate monotonic clock readable from user space. It mainly
> implies an atomic update of the time value. I am also trying to figure a
> way to support architectures with multiple CPUs with non-synchronized
> TSCs.
> 
> I would like to have your comments on the following idea.
> 
> Thanks in advance,
> 
> Mathieu
> 
> 
> Monotonic accurate time
> 
> The goal of this design is to provide a monotonic time :
> 
> Readable from userspace without a system call
> Readable from NMI handler
> Readable without disabling interrupts
> Readable without disabling preemption
> Only one clock source (most precise available : tsc)
> Support architectures with variable TSC frequency.

I don't think you could use only the tsc. From reviewing John, and
Thomas work it's pretty clear the TSC isn't going to work correctly all
the time.

> /* On frequency change event */
> /* In irq context */
> void freq_change_cb(unsigned int new_freq)
> {

It's possible for the TSC to change frequencies without notification. It
can also completely stop when the system goes idle.

> /* Userspace */
> /* Export all this data to user space through the vsyscall page. Use a function
>  * like read_time to read the walltime. This function can be implemented as-is
>  * because it doesn't need to disable preemption. */

What would be the benefit of using this over the vsyscall gettimeofday()
from userspace ? 

Daniel

