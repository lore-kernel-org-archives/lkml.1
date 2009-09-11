Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZIKBOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZIKBOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZIKBOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:14:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbZIKBOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:14:36 -0400
Date: Thu, 10 Sep 2009 18:13:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: David Daney <ddaney@caviumnetworks.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH 02/10] x86: Convert BUG() to use unreachable()
In-Reply-To: <4AA9A031.5000602@zytor.com>
Message-ID: <alpine.LFD.2.01.0909101806110.3654@localhost.localdomain>
References: <4AA991C1.1050800@caviumnetworks.com> <1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com> <4AA9A031.5000602@zytor.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Sep 2009, H. Peter Anvin wrote:

> On 09/10/2009 04:56 PM, David Daney wrote:
> > Use the new unreachable() macro instead of for(;;);.  When
> > allyesconfig is built with a GCC-4.5 snapshot on i686 the size of the
> > text segment is reduced by 3987 bytes (from 6827019 to 6823032).
> > 
> > Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Ingo Molnar <mingo@redhat.com>
> > CC: "H. Peter Anvin" <hpa@zytor.com>
> > CC: x86@kernel.org
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> ... although of course this clashes with Roland McGrath's patchset for
> the same thing which I applied earlier.  I have to say I like
> unreachable() in lower case better though...

I like David's version a bit better, since it takes care of more 
architectures, and also because it avoids that butt-ugly special case for 
gcc-4.4.1-RH-relase-10 backporting this feature.

I realize that the RH backport thing is good for testing now, but at the 
same time, it really does look nasty. I wonder if we could add some 
config-time compiler feature testing - so that you'd not have a version 
test at all, but a CONFIG_BUILTIN_UNREACHABLE.

There are other cases where that kind of config-time testing could be 
useful, and we could avoid doing various gcc checks dynamically from 
within 'make' (along with checking for known-buggy versions etc).

And yeah, it looks better in lower case. That said, I don't care _that_ 
much, and people can fight it out. 

		Linus
