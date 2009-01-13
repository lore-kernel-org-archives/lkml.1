Return-Path: <linux-kernel-owner+w=401wt.eu-S1757845AbZAMCPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757845AbZAMCPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 21:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbZAMCPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 21:15:06 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:51741 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZAMCPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 21:15:05 -0500
Date: Mon, 12 Jan 2009 18:14:59 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, andi@firstfloor.org,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090113021459.GB20594@localdomain>
References: <20090112213539.GA10720@gambetta> <20090112223421.GA20594@localdomain> <20090112230052.GB18771@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112230052.GB18771@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 12:00:52AM +0100, Ingo Molnar wrote:
>
>
>> With per-cpu areas, locks belonging to different array elements did not 
>> end up on the same internode cacheline due to per-node allocation of 
>> per-cpu areas, but with a simple array, two locks could end up on the 
>> same internode cacheline.
>> 
>> Hence, can you please change the padding in smp_flush_state to 
>> INTERNODE_CACHE_BYTES (you have to derive this off 
>> INTERNODE_CACHE_SHIFT) and align it using 
>> ____cacheline_internodealigned_in_smp?
>
>Yes, that matters to vsmp, which has ... 4K node cache-lines.
>
>Note that there's already CONFIG_X86_INTERNODE_CACHE_BYTES which is set 
>properly on vsmp.
>
>So ... something like the commit below?
>

Yep.  Looks good!

Acked-by: Ravikiran Thirumalai <kiran@scalex86.org>

Thanks,
Kiran
