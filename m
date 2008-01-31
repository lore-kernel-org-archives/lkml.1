Return-Path: <linux-kernel-owner+w=401wt.eu-S1765910AbYAaKP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765910AbYAaKP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbYAaKPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:15:12 -0500
Received: from mx1.suse.de ([195.135.220.2]:50898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196AbYAaKPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:15:11 -0500
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, npiggin@suse.de,
       riel@redhat.com, mztabzr@0pointer.de, mpm@selenic.com
Subject: Re: [PATCH] mm: MADV_WILLNEED implementation for anonymous memory
From: Andi Kleen <andi@firstfloor.org>
References: <1201714139.28547.237.camel@lappy>
	<20080130144049.73596898.akpm@linux-foundation.org>
	<1201769040.28547.245.camel@lappy>
	<20080131011227.257b9437.akpm@linux-foundation.org>
	<1201772118.28547.254.camel@lappy>
	<20080131014702.705f1040.akpm@linux-foundation.org>
	<1201773206.28547.259.camel@lappy>
Date: Thu, 31 Jan 2008 11:15:08 +0100
In-Reply-To: <1201773206.28547.259.camel@lappy> (Peter Zijlstra's message of "Thu\, 31 Jan 2008 10\:53\:26 +0100")
Message-ID: <p73ve5a47yr.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
>
> Ah, that is Lennarts Pulse Audio thing, he has samples in memory which
> might not have been used for a while, and he wants to be able to
> pre-fetch those when he suspects they might need to be played. So that
> once the audio thread comes along and stuffs them down /dev/dsp its all
> nice in memory.

The real problem that seems to make swapping so slow is that the data
tends to be badly fragmented on the swap partition. I suspect if that
problem was attached the need for such prefetching would be far less
because swap in would be much faster.

-Andi
