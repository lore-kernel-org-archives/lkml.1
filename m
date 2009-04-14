Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZDNEa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZDNEa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 00:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZDNEaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 00:30:15 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:49430 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbZDNEaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 00:30:14 -0400
Message-ID: <49E4108A.8050201@cs.columbia.edu>
Date: Tue, 14 Apr 2009 00:26:50 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       serue@us.ibm.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
References: <20090410023207.GA27788@x200.localdomain> <1239340031.24083.21.camel@nimitz> <20090413091423.GA19236@x200.localdomain>
In-Reply-To: <20090413091423.GA19236@x200.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Alexey Dobriyan wrote:
> On Thu, Apr 09, 2009 at 10:07:11PM -0700, Dave Hansen wrote:
>> I'm curious how you see these fitting in with the work that we've been
>> doing with Oren.  Do you mean to just start a discussion or are you
>> really proposing these as an alternative to what Oren has been posting?
> 
> Yes, this is posted as alternative.
> 
> Some design decisions are seen as incorrect from here like:

A definition of "design" would help; I find most of your comments
below either vague, cryptic, or technical nits...

> * not rejecting checkpoint with possible "leaks" from container

...like this, for example.
Anything in the current design makes it impossible ?

Anything prohibiting your from adding this feature to the current
patch-set ?

> * not having CAP_SYS_ADMIN on restart(2)

Surely you have read already on the containers mailing list that
for the *time being* we attempt to get as far as possible without
requiring root privileges, to identify security hot-spots.

And surely you have read there the observation that for the general
case root privileges will probably be inevitable.

And surely you don't seriously think that adding this check changes
the "design"...

> * having small (TASK_COMM_LEN) and bigger (objref[1]) image format
>   misdesigns.

Eh ?

> * doing fork(2)+restart(2) per restarted task and whole orchestration
>   done from userspace/future init task.

Why is it "incorrect" ?
What makes it "better" to do it in the kernel ?
Only because you say so is not convincing.

(also see my other post in this matter).

> * not seeing bigger picture (note, this is not equivalent to supporting
>   everything at once, nobody is asking for everything at once) wrt shared
>   objects and format and code changes because of that (note again, image
>   format will change, but it's easy to design high level structure which
>   won't change)

Why don't you describe the bigger picture so that the rest of can
finally see it, too ?!
(what a waste to have spent all this effort in vain...)

> * checking of unsupported features done at wrong place and wrong time
>   and runtime overhead because of that on CR=y kernels.

Eh ?   Did you follow the code recently ?

> 
> There are also low-level things, but it's cumulative effect.
> 
> [1] Do I inderstand correctly that cookie for shared object is an
> address on kernel stack? This is obviously unreliable, if yes :-)

Ah... I see... you didn't look at it that hard, not even read the
documentation with the code.

> 
> 	int objref;
> 		...
> 	/* adding 'file' to the hash will keep a reference to it */
> 	new = cr_obj_add_ptr(ctx, file, &objref, CR_OBJ_FILE, 0);
> 					^^^^^^^

That said, there are more similarities than differences between your
suggested template and the current patchset. With your expertise you
can contribute tremendously if you decide to work together.

Oren.
