Return-Path: <linux-kernel-owner+w=401wt.eu-S1761351AbZDQPMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761351AbZDQPMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758541AbZDQPMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:12:03 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:41682 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760475AbZDQPMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:12:01 -0400
Date: Fri, 17 Apr 2009 11:04:41 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
In-Reply-To: <1239979901.23397.4638.camel@laptop>
Message-ID: <alpine.DEB.1.10.0904171100510.21575@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>  <1239951613.23397.4107.camel@laptop>  <alpine.DEB.1.10.0904170941020.11877@qirst.com>  <1239977776.23397.4590.camel@laptop>  <alpine.DEB.1.10.0904171021360.20239@qirst.com>
 <1239979901.23397.4638.camel@laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Apr 2009, Peter Zijlstra wrote:

> And a random 1us cutoff, is well, random.

Its got to be somewhere.

> If you want to reduce interrupts, that's fine, but not counting an
> interrupt because its below the magic 1us marker sounds a bit, well,
> magic -- might work for you, might not for me on another machine, might
> even be compiler dependent.

The point is to reduce the interrupts of user space application. Hardware
interrupts etc are something else. Maybe I should not use the term
interrupt. Cpu unavailability? Cache pollution?

> So 5 <1us interruption are not at all accounted, whereas a single 1>us
> interruption is. I'd rather get rid of those 5 than try and shave a bit
> of the one, if you get what I mean.

Ok. We can set the threshold lower and see how that goes.

> Furthermore, yes the scheduler is one of those jiffy tick users, but
> there are more. We can do ntp/gtod things in there, there is process
> accounting, there is some RCU machinery, timers etc..

Again things were fine before the scheduler changed.

Could we defer interrupts if a single process is running on a cpu and
there is no other process on the runqueue and no other use of the timer
interrupt?

