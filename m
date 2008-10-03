Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481AbYJCPVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481AbYJCPVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYJCPVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:21:17 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:50343 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbYJCPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:21:16 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression] Latest git has WARN_ON storm with e1000e driver
Date: Fri, 3 Oct 2008 17:20:53 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <200810031041.49350.borntraeger@de.ibm.com> <alpine.LFD.2.00.0810030746430.3230@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810030746430.3230@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810031720.53923.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 3. Oktober 2008 schrieben Sie:
> Which spinlock is it? It sure shouldn't be anything in the generic drievr 
> layer: __driver_attach takes a lock, but it's a semaphore (dev->sem), not 
> a spinlock. In fact, al lot of drivers will sleep or do allocations, so if 
> the driver layer were to call the probe function with a spinlock held, 
> things would be really broken.
> 
> The callchain has "spin_lock_irqsave" in it, but that's stale stack data. 

Very good point indeed. Seems my analysis was wrong. I made a short test and 
preempt_count() returns 1 when the WARN_ON triggers. So its either a spinlock 
or something else that increased my preempt_count.
