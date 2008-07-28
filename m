Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYG1XVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYG1XVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751563AbYG1XU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:20:58 -0400
Received: from gw.goop.org ([64.81.55.164]:57646 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbYG1XU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:20:58 -0400
Message-ID: <488E5455.6010901@goop.org>
Date: Mon, 28 Jul 2008 16:20:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
References: <488E534F.2030204@goop.org>
In-Reply-To: <488E534F.2030204@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend to cc: Andi on an address which actually works.

Jeremy Fitzhardinge wrote:
> Now that normal smp_function_call is no longer an enormous bottleneck, 
> is there still value in having a specialised IPI vector for tlb 
> flushes?  It seems like quite a lot of duplicate code.
>
> The 64-bit tlb flush multiplexes the various cpus across 8 vectors to 
> increase scalability. If this is a big issue, then the smp function 
> call code can (and should) do the same thing.  (Though looking at it 
> more closely, the way the code uses the 8 vectors is actually a less 
> general way of doing what smp_call_function is doing anyway.)
>
> Thoughts?
>
> (And uv should definitely be hooking pvops if it wants its own 
> flush_tlb_others; vsmp sets the precedent for a subarch-like use of 
> pvops.)
>
>    J
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

