Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYATDeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYATDeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 22:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYATDdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 22:33:50 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:53282 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYATDdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 22:33:49 -0500
Date: Sun, 20 Jan 2008 09:03:38 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: dAniel hAhler <dhahler@googlemail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Regression with idle cpu cycle handling in 2.6.24 (compared to
	2.6.22)
Message-ID: <20080120033337.GA8277@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <bcadbdf50801190605s212ebe26n3035d8664554f636@mail.gmail.com> <bcadbdf50801190652s75f36b1ai422d8b12c5e8ff95@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcadbdf50801190652s75f36b1ai422d8b12c5e8ff95@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 03:52:44PM +0100, dAniel hAhler wrote:
> Hello,
> 
> I've now found the reason and a workaround for this. Apparently, it's
> related to CONFIG_FAIR_USER_SCHED and can be worked around by
> assigning a really small value to the boinc users cpu_share (125 is
> the uid of "boinc"):
> $ echo 2 | sudo tee /sys/kernel/uids/125/cpu_share
> 

Correct, that is the way to go about it.

> While looking around, I've found the following patch, which seems to
> address this:
> http://www.ussg.iu.edu/hypermail/linux/kernel/0710.3/3849.html
> 
> It has been posted here, but without any response.
> 
> btw: writing 1 into "cpu_share" totally locks up the computer!
> 

Can you please provide some more details. Can you go into another
console (try ctrl-alt-f1) and try to reproduce the issue there. Could
you take a photo of the oops/panic and upload it somewhere so that we
can see it?

Thanks
-- 
regards,
Dhaval
