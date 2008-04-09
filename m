Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYDIE5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYDIE5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 00:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYDIE5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 00:57:05 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:48272 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752092AbYDIE5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 00:57:04 -0400
Message-ID: <47FC4C9B.1030703@gawab.com>
Date: Tue, 08 Apr 2008 21:56:59 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Regression: 2.6.25-rc5: Blank Screen: Intel 945]
References: <47D828BB.2000702@gawab.com> <200803251308.43830.jbarnes@virtuousgeek.org> <47F13A74.8010206@gawab.com> <200804011322.58259.jbarnes@virtuousgeek.org>
In-Reply-To: <200804011322.58259.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> Yeah, seems pretty weird.  Given that you see it w/o the fb stuff loaded as 
> well and we still have a few open bugs against the intel X driver regarding 
> VT switch & mode programming, I don't think this is a real kernel regression.  
> It's more likely that some timing or memory layout changed subtly and is 
> causing to to hit one of our existing bugs more frequently that you did 
> before.  Can you file a bug against the intel X driver at 
> bugs.freedesktop.org so we can track it there?  Unless we can find a way to 
> reproduce it reliably it'll probably take a long time to fix, but we don't 
> want to lose it either...

Well, I'll file a bug on bugs.freedesktop.org, but if you don't think 
it's a kernel regression then I'll wait until the final release of 
2.6.25 comes out (unless you _really_ need me to file it sooner).

I still think it's somehow related to something that changed in the 
kernel from v24 to v25 because I've never had it happen with a kernel 
version less that 2.6.25. You say it's a timing issue; I've searched and 
found two things that have changed in v25: Preemptive RCU and I/O Port 
Delay.

I've enabled both preemptive RCU and no I/O port delay. I've recompiled 
with both disabled and found that the blank screen _still_ happens. So, 
I'm figuring that _maybe_ by adding these options the kernel developers 
needed to change something that exposes something related to the intel 
X.org driver that's no longer necessarily true
(or something like that - do you get what I'm trying to say).

This is what I have in my config:
> CONFIG_PREEMPT_RCU=y
> CONFIG_IO_DELAY_NONE=y

By the way is the intel driver that you work on the same that's enabled by:
> CONFIG_AGP_INTEL=m
> CONFIG_DRM_I915=m

Or is there another X.org intel driver? And if so how are they 
(agp/drm/X.org) related?

Justin
