Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZDVAQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZDVAQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZDVAQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:16:19 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:44100 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbZDVAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:16:19 -0400
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: C/R without "leaks"
References: <49E40662.2040508@cs.columbia.edu>
 <20090414163633.GE27461@x200.localdomain> <49E4D89D.9060903@cs.columbia.edu>
 <20090415195629.GD26994@x200.localdomain> <49E653C0.7020907@cs.columbia.edu>
From: Nathan Lynch <ntl@pobox.com>
Date: Tue, 21 Apr 2009 19:16:05 -0500
In-Reply-To: <49E653C0.7020907@cs.columbia.edu> (Oren Laadan's message of
 "Wed\, 15 Apr 2009 17\:38\:08 -0400")
Message-ID: <m3ocupmtkq.fsf@pobox.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: CC9E84CA-2ED2-11DE-9F5A-C121C5FC92D5-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan <orenl@cs.columbia.edu> writes:
> Alexey Dobriyan wrote:
>>> Again, so to checkpoint one task in the topmost pid-ns you need to
>>> checkpoint (if at all possible) the entire system ?!
>> 
>> One more argument to not allow "leaks" and checkpoint whole container,
>> no ifs, buts and woulditbenices.
>> 
>> Just to clarify, C/R with "leak" is for example when process has separate
>> pidns, but shares, for example, netns with other process not involved in
>> checkpoint.
>> 
>> If you allow this, you lose one important property of checkpoint part,
>> namely, almost everything is frozen. Losing this property means suddenly
>> much more stuff is alive during dump and you has to account to more stuff
>> when checkpointing. You effectively checkpointing on live data structures
>> and there is no guarantee you'll get it right.
>
> Alexey, we're entirely on par about this: everyone agrees that if you
> want the maximal guarantee (if one exists) you must checkpoint entire
> container and have no leaks.
>
> The point I'm stressing is that there are other use cases, and other
> users, that can do great things even without full container. And my
> goal is to provide them this capability.

As it seems that Alexey's goal is more or less a subset of yours, would
it make sense in the near term to concentrate on getting an
implementation upstream that satisfies that subset (i.e. checkpoint on a
container basis only)?  And then support for checkpointing arbitrary
processes could be added later, if it proves feasible?
