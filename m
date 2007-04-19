Return-Path: <linux-kernel-owner+w=401wt.eu-S1767004AbXDSVfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767004AbXDSVfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422708AbXDSVfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:35:25 -0400
Received: from gw.goop.org ([64.81.55.164]:44451 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422667AbXDSVfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:35:24 -0400
Message-ID: <4627E099.209@goop.org>
Date: Thu, 19 Apr 2007 14:35:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 10/28] i386: map enough initial memory to create lowmem
 mappings
References: <20070414204154.871250608@goop.org> <200704192250.52633.ak@suse.de> <4627D756.5020405@zytor.com> <200704192304.01053.ak@suse.de> <4627DB0C.2010804@zytor.com> <4627DDAD.4070805@redhat.com>
In-Reply-To: <4627DDAD.4070805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> H. Peter Anvin wrote:
>   
>> Andi Kleen wrote:
>>     
>>> Then we would have seen reports surely?
>>>       

Yes, I would have thought so.  It surprised me that such an obvious bug
could be there, apparently for a long time.  But it's real, and
potentially affects everyone.  It probably doesn't affect highly modular
distros much, since the kernel itself will be relatively small.

> I never saw a description of the symptoms of encountering this bug.
> Does it just hang, or what?
>   

You get an early-fault message on-screen, assuming that's enabled;
otherwise it will just appear to hang.  It happens in pagetable_init,
when it allocates a new pagetable above the head.S mapping (8M in my
case).  It will only hit if the kernel size approaches a 4M boundary,
since it won't leave enough space mapped to construct the lowmem mappings.

It only affects native booting, since under Xen all those mappings have
already been constructed.  It happened to me with a paravirt kernel that
happened to Xen compiled into it, but that was irrelevent (though
misleading; the 40k difference in kernel size was enough to make it not
happen in a non-Xen kernel).

    J
