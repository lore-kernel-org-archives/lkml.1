Return-Path: <linux-kernel-owner+w=401wt.eu-S935025AbXKPVjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935025AbXKPVjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933302AbXKPVin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:38:43 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37910 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935056AbXKPVim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:38:42 -0500
Date: Fri, 16 Nov 2007 13:38:40 -0800
From: Micah Dowty <micah@vmware.com>
To: David Newall <david@davidnewall.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: High priority tasks break SMP balancer?
Message-ID: <20071116213840.GA31527@vmware.com>
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net> <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com> <20071115191408.GA4914@vmware.com> <473DEBDD.2010706@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473DEBDD.2010706@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 05:43:33AM +1030, David Newall wrote:
> There are a couple of points I would make about your python test harness.  
> Your program compares real+system jiffies for both cpus; an ideal result 
> would be 1.00.  The measurement is taken over a relatively short period of 
> approximately a half-second, and you kill the CPU hogs before taking final 
> measurements, even wait for them to die first.  You repeat this 
> measurement, starting and killing CPU hogs each time.  Why do you do that?

The Python test harness is fairly artificial, but this is just the
best way I found to reliably reproduce the problem in a short amount
of time. It was just for convenience while running git-bisect. When
running the C program directly, there seems to be a somewhat random
chance that it will start up in the "bad" state. Once the single CPU
is stuck in this mostly-idle mode, it seems to stay that way for a
while.

> What happens if you start the hogs and take the baseline outside of the 
> loop?

The problem still occurs then, but killing/restarting the test app
seems to trigger the problem more reliably. As I said in the original
email about this, left to its own devices this problem will occur
seemingly-randomly. In the original VMware code I observed this
problem in, the same process would flip between the "good" and "bad"
states seemingly randomly, every few seconds.

Thanks,
--Micah

