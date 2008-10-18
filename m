Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbYJRH4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbYJRH4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 03:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYJRH4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 03:56:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50496 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYJRH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 03:56:24 -0400
To: "Ani Sinha" <kernel@anirban.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: panic() logic
From: Andi Kleen <andi@firstfloor.org>
References: <13c67e2c0810171448o6858827ei1ccc9e0ddf487f8@mail.gmail.com>
Date: Sat, 18 Oct 2008 09:56:22 +0200
In-Reply-To: <13c67e2c0810171448o6858827ei1ccc9e0ddf487f8@mail.gmail.com> (Ani Sinha's message of "Fri, 17 Oct 2008 14:48:18 -0700")
Message-ID: <87iqrqjpzt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Ani Sinha" <kernel@anirban.org> writes:

> I noticed an issue with the panic() firing on a back core in SMP
> lately. We are mostly working on mips architectures but it might
> effect other archs as well. Therefore, I am putting forward my
> thoughts and comments to the whole linux community. In the following,
> by front core I mean core#0 and by back core I mean other cores.

Why exactly is the "front core" special? 

> smp_send_stop basically marks all the other cores as 'down' and
> updates the cpu bitmap. One implication of this is that you can not do
> an IPI later on to other cores (smp_send_function() does a
> 'for_earch_online_cpu'). This makes sense since you should not be
> allowed to do anything on a down cpu. But what if a particular
> architecture had logic to do specific things for the front core and
> other things on the back cores as a part of 'graceful reboot' process?

Is that logic in Linux or in the platform?

Normally it's best to not rely on any specific CPU for panic.
What do you do when that CPU is so broken that it cannot
process IPIs anymore?

-Andi

-- 
ak@linux.intel.com
