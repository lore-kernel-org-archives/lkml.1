Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbXHTOm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbXHTOm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 10:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXHTOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 10:42:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752502AbXHTOmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 10:42:50 -0400
Message-ID: <46C9A867.6090509@redhat.com>
Date: Mon, 20 Aug 2007 10:42:47 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Anand Jahagirdar <anandjigar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>	 <46C4BC46.7000305@redhat.com> <25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>
In-Reply-To: <25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anand Jahagirdar wrote:
> Hi
>    As Per the Previous Discussion of my Patch,I think insted of using
> KERN_CRIT,it is better to lower the priority level to KERN_WARNING.
> thats why i used KERN_WARNING.it will warn administrator and its
> administrator responsibility to take whatever action he want to take.
> 
> anand

Philosophically, I'm okay with the idea of a forkbomb meriting KERN_WARN 
priority, but we should never have a printk that can be trivially triggered by 
an unprivileged user that gets anything higher than KERN_INFO.  If I'm an 
attacker, and I want to do bad things without getting logged, the first thing I 
do is launch a carefully-tuned forkbomb that doesn't bog down the system, just 
triggers this message as often as the ratelimit will allow.  Once /var/log is 
full, I can do my nastiness.  Administrators need to be able to protect against 
that kind of thing without losing the ability to log KERN_WARN and higher 
priority messages.

Also, I stand by my assertion that we should only be complaining if the hard 
limit is also exceeded, since it's totally valid for an application to 
self-constrain using soft limits.  It may be uncommon, but the people who happen 
to use whatever applications do this will be very unhappy when they update their 
kernel and /var fills up from this spew.

	-- Chris
