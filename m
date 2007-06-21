Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbXFUUMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbXFUUMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755818AbXFUUMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:12:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58746 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492AbXFUUL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:11:59 -0400
Date: Thu, 21 Jun 2007 13:10:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
In-Reply-To: <20070621195659.GA22303@elte.hu>
Message-ID: <alpine.LFD.0.98.0706211304480.3593@woody.linux-foundation.org>
References: <20070620093612.GA1626@ff.dom.local>
 <alpine.LFD.0.98.0706201018290.3593@woody.linux-foundation.org>
 <20070621073031.GA683@elte.hu> <alpine.LFD.0.98.0706210845090.3593@woody.linux-foundation.org>
 <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com>
 <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org>
 <20070621202917.a2bfbfc7.dada1@cosmosbay.com>
 <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org>
 <20070621195659.GA22303@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Ingo Molnar wrote:
> 
> I can understand why no data is saved by this change: gcc is aligning 
> the next field to a natural boundary anyway and we dont really have 
> arrays of spinlocks (fortunately).

Actually, some data structures could well shrink.

Look at "struct task_struct", for example. Right now it has two spinlocks 
right next to each other (alloc_lock and pi_lock).

Other data structures may have things like bitfields etc.

But yeah, I'd not expect that to be very common, and in some cases you 
might have to re-order data structures to take advantage of better 
packing, and even then it's probably not all that noticeable.

> but this is certainly not something for 2.6.22, it's an early 2.6.23 
> matter i suspect.

Oh, absolutely.

		Linus
