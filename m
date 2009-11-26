Return-Path: <linux-kernel-owner+w=401wt.eu-S1751464AbZKZRsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbZKZRsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbZKZRsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:48:42 -0500
Received: from smtp-out.google.com ([216.239.33.17]:37563 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbZKZRsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:48:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=ZEJ14KT/+3Gwuthi/LZouPFkoLA8+ll7LPPCfxD+DHz36w6ao9ocMKOJxHtsFuC3i
	FBLdPbOOELPyLVHWcIJ/w==
MIME-Version: 1.0
In-Reply-To: <1259257016.31676.308.camel@laptop>
References: <4b0eb9ce.0508d00a.573b.ffffeab6@mx.google.com>
	 <1259257016.31676.308.camel@laptop>
Date: Thu, 26 Nov 2009 18:48:43 +0100
Message-ID: <bd4cb8900911260948j6fd743c1u26343073fd1abc46@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix read() bogus counts when in error state
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       perfmon2-devel@lists.sourceforge.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 6:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2009-11-26 at 09:24 -0800, Stephane Eranian wrote:
>>       When a pinned group cannot be scheduled it goes into error state.
>>       Normally a group cannot go out of error state without being explicitly
>>       re-enabled or disabled. There was a bug in per-thread mode, whereby
>>       upon termination of the thread, the group would transition from error
>>       to off leading to bogus counts and timing information returned by
>>       read().
>
>>       Signed-off-by: Stephane Eranian <eranian@google.com>
>
> Right, good catch, totally forgot about error state :/
>
You need to clarify what pin actually means for per-thread
and I'd like to see an explanation for what happens when
sampling.
