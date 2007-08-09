Return-Path: <linux-kernel-owner+w=401wt.eu-S1763180AbXHIXQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763180AbXHIXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 19:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbXHIXQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 19:16:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40823 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbXHIXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 19:16:19 -0400
Date: Fri, 10 Aug 2007 01:16:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: i386 doublefault handler is broken with CONFIG_DEBUG_SPINLOCK
Message-ID: <20070809231618.GC1845@one.firstfloor.org>
References: <46BB4599.2020900@redhat.com> <p73zm10egym.fsf@bingen.suse.de> <46BB5F9B.6050808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BB5F9B.6050808@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 02:40:27PM -0400, Chuck Ebbert wrote:
> On 08/09/2007 01:49 PM, Andi Kleen wrote:
> > Chuck Ebbert <cebbert@redhat.com> writes:
> >> Initializing FS in the doublefault_tss should fix it.
> >>
> >> Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
> >>
> >> ---
> >>
> >>  NOTE: not even compile tested.
> > 
> > Can you please test it?
> > 
> 
> It compiles but I can't really test it further right now.

I tested it. Even on a box without spin lock debugging I get a hard
hang after

double fault, gdt at c1404000 [255 bytes]

even though it should have printed the registers.
So it looks like there is more broken in the DF handler than just
this.

-Andi
