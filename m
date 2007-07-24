Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbXGXXE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbXGXXE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 19:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbXGXXEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 19:04:21 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:42403
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXGXXEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 19:04:21 -0400
Date: Tue, 24 Jul 2007 16:02:46 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Power Management framework proposal
In-Reply-To: <1185313138.5439.285.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0707241556140.6590@asgard.lang.hm>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm> 
 <1185125189.2714.13.camel@laptopd505.fenrus.org> 
 <1185229405.5439.148.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0707241313580.6590@asgard.lang.hm>
 <1185313138.5439.285.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Benjamin Herrenschmidt wrote:

> On Tue, 2007-07-24 at 13:14 -0700, david@lang.hm wrote:
>>> I think we need a set of constraints that trickle down the power
>> tree
>>> and limit what a given driver can do locally.
>>
>> what sort of contraints are you thinking of?
>
> A parent power state defines what states children can be in. For
> example. A way to express those dependencies would be nice. Or
> alternatiely, the power state of all the children defines the power
> state a parent can go in automatically.

Ok, I see tow things here.

1. do you really want to try and propogate things like this from one to 
the other, or would it be good enough to flag the issue and let the 
software selecting the modes implement this contraint?

2. how can you standardize the requirements?

at the very least you have

for this mode all children must be off

for this mode all children must be in a mode that includes a 'suspended' 
flag (this could be made implicit by saying that you must suspend children 
before parents) and then just flagging the 'suspended, but not off' modes)

what requirements are needed? (I'm sure that there are others, but 
hopefully it's possible to avoid requirements like 'the clock speed for 
device A must be >X to allow device B to operate in mode Y')

David Lang
