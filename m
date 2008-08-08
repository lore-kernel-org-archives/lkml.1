Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbYHHSbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbYHHSbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYHHSb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:31:27 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:42284 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYHHSbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:31:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oiD3cMQyGWZQJkTSzDzpMJ4KaA8thJmjWPG4lsUOlxDY9xASuGAiACcQgFZkLlvayX
         np8SmgpOqvIAPyxFqk1WrwGpQoHZAj/slW8WshH7zsRLTabH+5Qnx3ikXQH2Mq+sJ5k6
         PIZ6GwutFkKhyrqZzscp0VEMeY65S2S/s6SA0=
Message-ID: <19f34abd0808081131p4e83cd79r8b7e0cb8da4f747b@mail.gmail.com>
Date: Fri, 8 Aug 2008 20:31:24 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Suresh Siddha" <suresh.b.siddha@intel.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Cc: wolfgang.walter@stwm.de, "Herbert Xu" <herbert@gondor.apana.org.au>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080806212152.GB607@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807171653.59177.wolfgang.walter@stwm.de>
	 <200807301411.01622.wolfgang.walter@stwm.de>
	 <20080806103354.GA31623@gondor.apana.org.au>
	 <200808061933.25631.wolfgang.walter@stwm.de>
	 <20080806201401.GA607@linux-os.sc.intel.com>
	 <20080806212152.GB607@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 11:21 PM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> BTW, in one of your oops, I see:
>
> note: cron[1207] exited with preempt_count 268435459
>
> I smell some kind of stack corruption here which is corrupting
> thread_info (in the above case preempt_count in the thread_info).
>
> Similarly, if the status field(in thread_info) gets corrupted(setting
> TS_USEDFPU) without proper math state allocated(present in thread_struct),
> we can end up oops in __switch_to.
>
> But you seem to say, reverting recent fpu patches make the problem go away.
> hmm, just wondering if your test kernel (with fpu patches reverted) is stable
> enough and don't see other oops/issues?
>
> Recently Vegard also noticed some stack corruptions (in network stack) leading
> to similar problems. Not sure if Vegard has root caused his issue. copying him
> for his comments.

I don't think this is the same problem. What I see is almost certainly
a problem with netpoll, netconsole, or the 8139too driver. I see a UDP
packet in a task_struct.

There is also the fact that reverting fpu patches makes it go away
(for Wolfgang), while for the issue I am seeing, oops in FP code is
just one out of several different corruptions (sometimes it happens in
other slabs).

(Sorry for the little late reply.)

Thanks.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
