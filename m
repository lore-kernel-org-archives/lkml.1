Return-Path: <linux-kernel-owner+w=401wt.eu-S1161128AbXBZVaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161128AbXBZVaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030567AbXBZVaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:30:08 -0500
Received: from h155.mvista.com ([63.81.120.158]:48822 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1161224AbXBZV37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:29:59 -0500
Subject: Re: [RFC] Fast assurate clock readable from user space and NMI
	handler
From: Daniel Walker <dwalker@mvista.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: mbligh@google.com, linux-kernel@vger.kernel.org, johnstul@us.ibm.com
In-Reply-To: <20070226205304.GA30800@Krystal>
References: <20061124215904.GI25048@Krystal>
	 <1164475747.5196.5.camel@localhost.localdomain>
	 <20061126170542.GA30771@Krystal>
	 <1164561427.16871.14.camel@localhost.localdomain>
	 <20061126231833.GA22241@Krystal>
	 <1164585589.16871.52.camel@localhost.localdomain>
	 <20070224161906.GA9497@Krystal> <1172340369.24216.31.camel@imap.mvista.com>
	 <20070226205304.GA30800@Krystal>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 13:27:41 -0800
Message-Id: <1172525261.5517.69.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 15:53 -0500, Mathieu Desnoyers wrote:

> > > /* On frequency change event */
> > > /* In irq context */
> > > void freq_change_cb(unsigned int new_freq)
> > > {
> > 
> > It's possible for the TSC to change frequencies without notification. It
> > can also completely stop when the system goes idle.
> > 
> 
> Hrm, I see. I though those freq change without notification would happen
> rarely and could be dealt by resynchronizing the CPUs. I guess I was
> wrong.

The system could be UP .. I don't think tracking this kind of thing is
trival, and given the TSC track record you have to assume there are will
be other issue in the future.

> > > /* Userspace */
> > > /* Export all this data to user space through the vsyscall page. Use a function
> > >  * like read_time to read the walltime. This function can be implemented as-is
> > >  * because it doesn't need to disable preemption. */
> > 
> > What would be the benefit of using this over the vsyscall gettimeofday()
> > from userspace ? 
> > 
> 
> So we can get a monotonic, non NTP corrected timestamp quickly from user
> space without going through a system call. Are there other alternatives ?

The NTP daemon needs to be active AFAIK before you would start observing
weird time jumps. There are adjustments made without NTP but they are
only seen over short periods.. So I still think gettimeofday() would be
an alternative ..

Have you considered adding something to glibc? You could access only the
TSC from userspace.. I don't think the addition of a vsyscall/syscall
for this would go over too well considering that there are other ways to
get timestamps. It might help if you tell us what you think this would
be used for in userspace ?

Daniel

