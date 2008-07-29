Return-Path: <linux-kernel-owner+w=401wt.eu-S1759905AbYG2Rt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbYG2Rt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbYG2RtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:49:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49126 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbYG2RtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:49:17 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5349"; a="4977146"
Message-ID: <488F581B.7060009@qualcomm.com>
Date: Tue, 29 Jul 2008 10:49:15 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
CC: Peter Oruba <peter.oruba@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] x86: AMD microcode patch loading v2 fixes
References: <20080729154103.007575982@amd.com> <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>
In-Reply-To: <b647ffbd0807290918kaa0a05es3cebf7a6f15fb790@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Adamushko wrote:
> 2008/7/29 Peter Oruba <peter.oruba@amd.com>:
>> Fixed coding style issues.
> 
> I have a comment on the abstraction layer (microcode_ops).
> 
> [ Not that I've looked very carefully at it so far, nor I pretend to
> be at-ease with this 'microcode' topic to make any design judgements
> :-) ]
> 
> but would it be somehow possible to not have set_cpus_allowed_ptr()
> code in arch-dependent parts? Let's say the mechanism of how to run
> certain arch-specific code (and synchronization) on a given cpu should
> be a prerogative of (and placed in) the generic part...
> 
> Note, this code will likely happily give you an oops if you run
> cpu_down/up() ;-)
> 
> I also wondered, is there a requirement that when a new cpu is brought
> up, microcode updates {should,must} be done as early as possible, say
> before any tasks have a chance to run on it? Or can the update be a
> bit delayed? e.g. we don't do it from cpu-hotplug handlers.

Dmitry looks like you missed my email. I already asked that question and 
proposed a couple of options (workqueue and ipi).
Tigran said that he does not know. Maybe Peter does.

My guess is that it does not have to be done synchronously and can be 
delayed. There is no guaranty that microcode CPU hotplug handler will 
run before all the other handlers. Which by definition means that some 
things will start running on the cpu before the microcode is updated. 
Hence we might as well do the update outside of the cpu hotplug path.

Max


