Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZEQXQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZEQXQ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbZEQXQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:16:46 -0400
Received: from fmailhost01.isp.att.net ([204.127.217.101]:35871 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZEQXQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:16:46 -0400
X-Originating-IP: [71.195.50.4]
Message-ID: <4A109AC5.7040008@lwfinger.net>
Date: Sun, 17 May 2009 18:16:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <_AjETDMbIoL.A.DcH.RYzDKB@chimera>	<385Pu-agh7M.A.SU.iYzDKB@chimera> <20090516163610.8a012268.akpm@linux-foundation.org>
In-Reply-To: <20090516163610.8a012268.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> Well..  order-1 GFP_ATOMIC allocations are unreliable.  The networking
> code should hanlde the situation and recover.  I assume that is
> happening in this case?

Yes, the driver has recovered in all cases so far.

> Perhaps we did something in that code after 2.6.29 which increased the
> frequency of the order-1 allocation attempts?  Maybe earlier kernels
> used order-0 all the time?  Those are much more reliable.

I think something happened to change the allocation as I never saw these O(1)
failures before with these particular drivers. I put in a few test printk's and
the buffers were 700-800 bytes long, and I would not expect them to require more
than an O(0) allocation.

I pushed 2.6.30-rc6 hard for ~12 hours without any recurrence of the problem.
Given the relative infrequency of the error, this certainly does not indicate a
fix in recent code. I will be trying to force it again.

Larry

