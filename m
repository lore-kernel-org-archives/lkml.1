Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbXK2AN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbXK2AN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXK2ANU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:13:20 -0500
Received: from namei.org ([69.55.235.186]:35867 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750850AbXK2ANT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:13:19 -0500
Date: Thu, 29 Nov 2007 11:12:40 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: tvrtko.ursulin@sophos.com
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: Out of tree module using LSM
In-Reply-To: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
Message-ID: <Xine.LNX.4.64.0711291000590.21270@us.intercode.com.au>
References: <OF74C1FF25.986585E9-ON802573A1.006239BF-802573A1.0064DE96@sophos.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, tvrtko.ursulin@sophos.com wrote:

> So as there is no question the current code does some ugly things it is 
> even more true that we would be even more happy to use an official API. 

How about becoming involved in creating that official API ?

"A person will stand on the top of a hill for a very long time with their 
mouth open before a roast duck will fly in"

> LSM was that and we were happily using it which we won't be able to do if 
> it abruptly goes away. Yes it is not a perfect match but until it is 
> modified to be better, or until something appropriate is designed and 
> implemented, it would be very nice if it could stay.

So, what you're asking for is for us to maintain infrastructure in the 
kernel, for your out of tree code, which we could not have even known 
about until it was dumped on sourceforge a couple of days ago ?

And you're expecting us to modify it to be "better", for you, but without 
us possibly knowing what you want ?

How is this sustainable?  Every time we make a change in the kernel code, 
do we have to wait for months while all of the (unknown) out of tree users 
discover their code is broken and then complain to Linus ?

Do you really thing we should be supporting developers who make zero 
effort to engage with the kernel community, and instead abuse kernel APIs 
and ship out of tree code to customers?

You are essentially demanding that we provide you with a stable kernel 
API.  I suggest you review Greg KH's excellent document on the issue: 
<http://os.cqu.edu.au/docs/kernel-doc/Documentation/stable_api_nonsense.txt>

Also, your users are likely unaware of the risks associated with these 
techniques, such as, that they are not actually running "linux" any more, 
and that their kernel is made unsupportable by both the community and 
their OS vendors when code like this is being used:

/*
 * hidden vfsmnt_lock handling
 */
#ifdef TALPA_USE_VFSMOUNT_LOCK
static inline void talpa_vfsmount_lock(void)
{
    spinlock_t* talpa_vfsmount_lock_addr = (spinlock_t *)TALPA_VFSMOUNT_LOCK_ADDR;

    spin_lock(talpa_vfsmount_lock_addr);
}

Code quality and correctness issues are definitely relevant, and in fact  
are directly linked to the fact that out of tree code receives no
community peer review, and is not able to be considered in the general
kernel design & development process.

Hacks like this effectively void support from the community, which is 
another way of saying that the user's kernel becomes proprietary once the 
module containing it is loaded.

Actually, it's worse than that, as not only is the kernel no longer "open 
source", but also lacks even the level of support provided by proprietary 
OS vendors (who provide stable interfaces for such purposes).

If you want to resolve this properly, you'll need to do more than complain 
to Linus when the upstream APIs (which you are abusing) change.

You'll need to become productively engaged in designing, developing and 
maintaining appropriate APIs, which suit not only your specific needs, but 
likely those of others, and submit your code for review and upstream 
inclusion.

What I'd suggest, is that you create a public mailing list, get the other 
AV projects involved, and then work on a set of requirements so that the 
general problem can be understood.  Then, propose a solution to the 
problem and have it reviewed by core kernel folk (cc it to lkml), so that 
it can be evaluated in terms of e.g. VFS correctness, maintainability etc.  

That would be at least a useful first step in taking this issue seriously.

Thanks,


- James 
-- 
James Morris 
<jmorris@namei.org>
