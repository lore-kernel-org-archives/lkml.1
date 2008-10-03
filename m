Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYJCPId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYJCPId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYJCPIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:08:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:59123 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYJCPIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:08:23 -0400
Date: Fri, 3 Oct 2008 08:08:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [regression] Latest git has WARN_ON storm with e1000e driver
Message-ID: <20081003080807.28349678@infradead.org>
In-Reply-To: <200810031041.49350.borntraeger@de.ibm.com>
References: <200810031041.49350.borntraeger@de.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008 10:41:49 +0200
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> This is caused by holding a spinlock (__driver_attach) and checking
> for preempt_count (e1000_acquire_swflag_ich8lan).
> 
> I suggest to revert this commit, since we cannot take a mutex while
> holding a spinlock.
> The simple solution of replacing the mutex with a spinlock does not
> work, since we call msleep on several places in the code. Replacing
> all that code doesnt look like 2.6.27 material.

hi,

could you do a run with frame pointers enabled?
that should clear up the stack noise....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
