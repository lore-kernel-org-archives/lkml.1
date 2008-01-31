Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbYAaKVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbYAaKVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYAaKV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:21:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752815AbYAaKV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:21:26 -0500
Date: Thu, 31 Jan 2008 02:19:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, hugh@veritas.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, npiggin@suse.de,
       riel@redhat.com, mztabzr@0pointer.de, mpm@selenic.com
Subject: Re: [PATCH] mm: MADV_WILLNEED implementation for anonymous memory
Message-Id: <20080131021949.92715ba4.akpm@linux-foundation.org>
In-Reply-To: <p73ve5a47yr.fsf@bingen.suse.de>
References: <1201714139.28547.237.camel@lappy>
	<20080130144049.73596898.akpm@linux-foundation.org>
	<1201769040.28547.245.camel@lappy>
	<20080131011227.257b9437.akpm@linux-foundation.org>
	<1201772118.28547.254.camel@lappy>
	<20080131014702.705f1040.akpm@linux-foundation.org>
	<1201773206.28547.259.camel@lappy>
	<p73ve5a47yr.fsf@bingen.suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 11:15:08 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> >
> > Ah, that is Lennarts Pulse Audio thing, he has samples in memory which
> > might not have been used for a while, and he wants to be able to
> > pre-fetch those when he suspects they might need to be played. So that
> > once the audio thread comes along and stuffs them down /dev/dsp its all
> > nice in memory.
> 
> The real problem that seems to make swapping so slow is that the data
> tends to be badly fragmented on the swap partition. I suspect if that
> problem was attached the need for such prefetching would be far less
> because swap in would be much faster.
> 

Yeah, the 2.5 switch to physical scanning killed us there.

I still don't know why my allocate-swapspace-according-to-virtual-address
change didn't help.  Much.  Marcelo played with that a bit too.

