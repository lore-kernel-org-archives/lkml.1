Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbXHNUdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbXHNUdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757334AbXHNUde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:33:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39704 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbXHNUde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:33:34 -0400
Date: Tue, 14 Aug 2007 22:33:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
Message-ID: <20070814203329.GA22202@one.firstfloor.org>
References: <20070814153021.446917377@sgi.com> <20070814153501.766137366@sgi.com> <p73vebhnauo.fsf@bingen.suse.de> <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> There are other lock interactions that may cause problems. If we do not 
> switch to the saving of irq flags then all involved spinlocks must become 
> trylocks because the interrupt could have happened while the spinlock is 
> held. So interrupts must be disabled on locks acquired during an 
> interrupt.

I was thinking of a per cpu flag that is set before and unset after
taking the lock in process context. If the flag is set the interrupt
will never try to take the spinlock and return NULL instead. 
That should be equivalent to cli/sti for this special case.

-Andi
