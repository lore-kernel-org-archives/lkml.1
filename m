Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZETVlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZETVlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 17:41:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZETVld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 17:41:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37372 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZETVlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 17:41:32 -0400
Message-ID: <4A147891.5000906@zytor.com>
Date: Wed, 20 May 2009 14:39:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, norsk5@yahoo.com,
       tglx@linutronix.de, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 01/22] x86: add methods for writing of an MSR on	several
 CPUs
References: <1242390153-24493-1-git-send-email-borislav.petkov@amd.com> <1242390153-24493-2-git-send-email-borislav.petkov@amd.com> <20090519172449.GB18874@aftab> <4A1392A9.9010609@zytor.com> <20090520144905.GA27991@aftab>
In-Reply-To: <20090520144905.GA27991@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> 
> We currently need them for enabling the NB error reporting bank over
> MCG_CTL on each core on the node. The question is whether we really need
> the concurrency when accessing an MSR on several cores. With MCG_CTL,
> BKDG says "It is expected that this register is programmed to the same
> value in all nodes," but nothing concerning concurrency.
> 
> But you're right, if this interface is supposed to be generic enough,
> it is probably wise to access an MSR concurrently. I could imagine
> an obscure case where this is required. However, is sending IPIs
> (smp_call_function_many) guaranteeing the needed concurrency? Or, should
> it be more like how the mtrr code jumps through hoops (set_mtrr())
> in order to ensure that _ALL_ registers have been written _before_
> continuing?
> 

smp_call_function_many() does allow concurrent execution.  Looping over
a list with smp_call_function_one() -- which you currently have -- is
serializing, at which point we might just push the loop into the caller
rather than worrying about a new interface.

	-hpa

