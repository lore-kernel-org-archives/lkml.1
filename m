Return-Path: <linux-kernel-owner+w=401wt.eu-S1757461AbYG1XQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461AbYG1XQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYG1XQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:16:35 -0400
Received: from gw.goop.org ([64.81.55.164]:49573 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbYG1XQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:16:34 -0400
Message-ID: <488E534F.2030204@goop.org>
Date: Mon, 28 Jul 2008 16:16:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: Is there still value in having a special tlb flush IPI vector?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that normal smp_function_call is no longer an enormous bottleneck, 
is there still value in having a specialised IPI vector for tlb 
flushes?  It seems like quite a lot of duplicate code.

The 64-bit tlb flush multiplexes the various cpus across 8 vectors to 
increase scalability. If this is a big issue, then the smp function call 
code can (and should) do the same thing.  (Though looking at it more 
closely, the way the code uses the 8 vectors is actually a less general 
way of doing what smp_call_function is doing anyway.)

Thoughts?

(And uv should definitely be hooking pvops if it wants its own 
flush_tlb_others; vsmp sets the precedent for a subarch-like use of pvops.)

    J
