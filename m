Return-Path: <linux-kernel-owner+w=401wt.eu-S934715AbXHNUmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715AbXHNUmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 16:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760344AbXHNUmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 16:42:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45246 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760059AbXHNUmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 16:42:24 -0400
Date: Tue, 14 Aug 2007 13:42:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
In-Reply-To: <20070814203329.GA22202@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com> <20070814153501.766137366@sgi.com>
 <p73vebhnauo.fsf@bingen.suse.de> <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com>
 <20070814203329.GA22202@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > There are other lock interactions that may cause problems. If we do not 
> > switch to the saving of irq flags then all involved spinlocks must become 
> > trylocks because the interrupt could have happened while the spinlock is 
> > held. So interrupts must be disabled on locks acquired during an 
> > interrupt.
> 
> I was thinking of a per cpu flag that is set before and unset after
> taking the lock in process context. If the flag is set the interrupt
> will never try to take the spinlock and return NULL instead. 
> That should be equivalent to cli/sti for this special case.

Hmmmm... The spinlock is its own flag. If the lock is taken then the flag 
is set. So if we check all relevant spinlocks before going into reclaim 
then we could return NULL.

