Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYBPOE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYBPOE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 09:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYBPOEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 09:04:50 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:22512 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYBPOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 09:04:49 -0500
Date: Sat, 16 Feb 2008 15:04:44 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       buytenh@wantstofly.org, mingo@elte.hu, riku.voipio@movial.fi,
       stable@kernel.org, schwidefsky@de.ibm.com
Subject: Re: + futex-runtime-enable-pi-and-robust-functionality.patch added
	to -mm tree
Message-ID: <20080216140444.GC4900@osiris.boeblingen.de.ibm.com>
References: <200802150149.m1F1n8Gx013909@imap1.linux-foundation.org> <20080216124248.GA4900@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0802161346350.7583@apollo.tec.linutronix.de> <20080216134155.GB4900@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0802161444510.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802161444510.7583@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2008 at 02:48:17PM +0100, Thomas Gleixner wrote:
> On Sat, 16 Feb 2008, Heiko Carstens wrote:
> 
> > > Well, NULL pointer dereferencing is supposed to fail, isn't it ?
> >
> > I wasn't sure that this is true for all architectures, but...
> 
> It's an requirement for futex support.

To be more precise: dereferencing alone won't cause an exception for
NULL pointers on s390. Only writes will do so.
That is very architecture specific since we cannot unmap page 0,
it contains per-cpu data -- like exception pointers and all such stuff
that the cpu needs.
Just in case there is any code that relies on the fact that also reads
via a NULL pointer are supposed to failed.
