Return-Path: <linux-kernel-owner+w=401wt.eu-S1764050AbYDVXV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764050AbYDVXV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYDVXVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:21:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbYDVXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:21:08 -0400
Date: Tue, 22 Apr 2008 16:20:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Subject: Re: [git patch] free_irq() fixes
In-Reply-To: <480E6DE5.6010103@garzik.org>
Message-ID: <alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
References: <20080422221733.GA16260@havoc.gtf.org> <alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org> <480E6DE5.6010103@garzik.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 Apr 2008, Jeff Garzik wrote:
> 
> (note, for mwave I couldn't use pSettings, since that might fail the ambiguity
> test)

Ok, so using the pointer to inside a specific pSettings field is fine.

But can you also explain to me why that insane driver does this:

	 static irqreturn_t UartInterrupt(int irq, void *dev_id)
	 {
	-       int irqno = (int)(unsigned long) dev_id;
	+       unsigned short *irqno = dev_id;
		...
		*irqno, dev_id);

instead of just ignoring "dev_id" entirely, and then just using that "irq" 
argument directly?

		Linus
