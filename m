Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZFYAO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZFYAO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZFYAOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:14:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57738 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbZFYAOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:14:50 -0400
Message-ID: <4A42C131.6040007@zytor.com>
Date: Wed, 24 Jun 2009 17:13:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       cl@linux-foundation.org
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <20090625000202.GR6760@one.firstfloor.org>
In-Reply-To: <20090625000202.GR6760@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> Haven't read the new patches, but per cpu data always was sized
> for all possible CPUs.
> 
>> and N is large, what did it cost?
> 
>> And what are reasonable values of N?
> 
> N should normally not be large anymore, since num_possible_cpus() 
> is sized based on firmware information now.
> 

*Ahem* virtual machines *ahem*...

I have discussed this with Tejun, and the plan is to allocate the percpu
information when a processor is first brought online (but not removed
when it is offlined again.)  It's a real problem for 32-bit VMs, so it's
more important than you'd think.

	-hpa

