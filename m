Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbXH0Psh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbXH0Psh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 11:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbXH0Ps1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 11:48:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:48599 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582AbXH0Ps0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 11:48:26 -0400
Message-ID: <46D2F1B7.70604@qumranet.com>
Date: Mon, 27 Aug 2007 18:45:59 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Implement emulator_write_phys()
References: <11882278064002-git-send-email-aliguori@us.ibm.com> <1188227808405-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <1188227808405-git-send-email-aliguori@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Since a hypercall may span two pages and is a gva, we need a function to write
> to a gva that may span multiple pages.  emulator_write_phys() seems like the
> logical choice for this.
>
> @@ -962,8 +962,35 @@ static int emulator_write_std(unsigned long addr,
>  			      unsigned int bytes,
>  			      struct kvm_vcpu *vcpu

I think that emulator_write_emulated(), except for being awkwardly 
named, should do the job.  We have enough APIs.

But!  We may not overwrite the hypercall instruction while a vcpu may be 
executing, since there's no atomicity guarantee for code fetch.  We have 
to to be out of guest mode while writing that insn.



-- 
Any sufficiently difficult bug is indistinguishable from a feature.

