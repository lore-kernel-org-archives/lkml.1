Return-Path: <linux-kernel-owner+w=401wt.eu-S934576AbZKYI4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934576AbZKYI4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 03:56:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934489AbZKYI4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 03:56:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:56516 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934449AbZKYI4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 03:56:04 -0500
Date: Wed, 25 Nov 2009 09:56:09 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091125085609.GF17484@wotan.suse.de>
References: <20091123145409.GA29627@wotan.suse.de> <20091124.121959.35689494.davem@davemloft.net> <87638zvvjg.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87638zvvjg.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 09:49:23AM +0100, Andi Kleen wrote:
> David Miller <davem@davemloft.net> writes:
> >
> > I think nobody would notice if you changed tasklist_lock into
> > a spinlock_t, and this would solve the DoS because at least on
> > x86 you'd end up with the ticket spinlocks.
> 
> iirc tasklist_lock was one of them who could be potentially nested.
> 
> So just turning it into a spinlock might deadlock.

It can be nested I think due to interrupt context. But if the read
side disables interrupts too, then I think it should be OK (though
I haven't audited this closely).

