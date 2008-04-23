Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYDXBYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYDXBYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 21:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYDXBYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 21:24:45 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:43881 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbYDXBYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 21:24:44 -0400
Message-ID: <480F3ECC.1090809@keyaccess.nl>
Date: Wed, 23 Apr 2008 15:51:08 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Adrian Bunk <bunk@kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [git patch] free_irq() fixes
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org> <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org> <480E796E.4070001@garzik.org> <alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org> <20080423000529.GG28933@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-04-08 02:16, Linus Torvalds wrote:

> On Wed, 23 Apr 2008, Adrian Bunk wrote:
>> If it goes like the regs removal in one big patch around -rc1 into your 
>> tree this shouldn't be a problem.
> 
> Well, the regs removal had a real upside (it wasn't even sensible for all 
> irq types), and really nobody used it apart from "system users" (ie Sysrq 
> etc).
> 
> I'm still waiting for anybody mentioning any upside at _all_ on removing 
> "irq".

Saves another 4 bytes of stack? :-/ Seriously, Jeff can probably better 
answer himself but when this was posted before:

http://lkml.org/lkml/2007/5/19/23

Eric Biederman said it fit nicely into his "nefarious plan of making 
everything use a struct irq pointer". A later mention:

http://lkml.org/lkml/2007/10/19/66

got strong ACKs from Thomas Gleixner, Ingo Molnar and Greg KH. Remember due 
to working on a local driver at the time and deleting the "irq" argument 
usage from its handler (unneccesarily used in a debugging printk) from it in 
response.

My own view is that if it's not really overly painful this does make for a 
nice API cleanliness thing -- the IRQ level is only relevant to the lower 
level generic handler code not the "driver endpoint handler" and not passing 
it in the first place thereby is in keeping with this layering.

Rene.
