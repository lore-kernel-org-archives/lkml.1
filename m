Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbZEGXou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbZEGXou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZEGXoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:44:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57498 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbZEGXoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:44:37 -0400
Date: Thu, 7 May 2009 20:43:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090507234311.GA9517@amt.cnet>
References: <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <20090507233503.GA9103@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507233503.GA9103@amt.cnet>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 07, 2009 at 08:35:03PM -0300, Marcelo Tosatti wrote:
> Also for PIO/MMIO you're adding this unoptimized lookup to the 
> measurement:
> 
>         pio_dev = vcpu_find_pio_dev(vcpu, port, size, !in);
>         if (pio_dev) {
>                 kernel_pio(pio_dev, vcpu, vcpu->arch.pio_data);
>                 complete_pio(vcpu); 
>                 return 1;
>         }
> 
> Whereas for hypercall measurement you don't. I believe a fair comparison
> would be have a shared guest/host memory area where you store guest/host
> TSC values and then do, on guest:
> 
> 	rdtscll(&shared_area->guest_tsc);
> 	pio/mmio/hypercall
> 	... back to host
> 	rdtscll(&shared_area->host_tsc);
> 
> And then calculate the difference (minus guests TSC_OFFSET of course)?

Test Machine: Dell Precision 490 - 4-way SMP (2x2) x86_64 "Woodcrest"
Core2 Xeon 5130 @2.00Ghz, 4GB RAM.

Also it would be interesting to see the MMIO comparison with EPT/NPT,
it probably sucks much less than what you're seeing.

