Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbYLXNnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbYLXNnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 08:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYLXNnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 08:43:05 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:53440 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbYLXNnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 08:43:02 -0500
Date: Wed, 24 Dec 2008 19:12:25 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: asterisk hangs with RT priority
Message-ID: <20081224134225.GA4666@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <483054DB.4030504@trash.net> <20081224113617.GA29037@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224113617.GA29037@gondor.apana.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 10:36:17PM +1100, Herbert Xu wrote:
> On Sun, May 18, 2008 at 06:10:03PM +0200, Patrick McHardy wrote:
> > I'm seeing hanging asterisk processes on startup when using
> > RT priority with current -git. Unfortunately I'm not sure about
> > the last working version, but it was one of the final 2.6.25 rcs.
> > The hang stops when executing "schedtool -N $(pidof asterisk)".
> 
> I'm now hitting exactly the same problem with 2.6.28-rc9 (I had
> it with 2.6.27 too but thought it might go away on its own :)
> 
> I've made a small program to attempt to reproduce this based on
> the asterisk code.  Unfortunately it doesn't work on its own.
> However, if you run it under strace then it does hang in the
> same away as asterisk (which seems to happen after the setuid
> call, as strace shows it before hanging and the printk after
> it in asterisk gets executed).
> 
> Note that the hang goes away if either setscheduler or setuid
> is removed.
> 

Hmm. Do you have CONFIG_FAIR_USER_SCHED set on?

Thanks,
-- 
regards,
Dhaval
