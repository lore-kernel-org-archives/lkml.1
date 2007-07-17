Return-Path: <linux-kernel-owner+w=401wt.eu-S1763064AbXGQA6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763064AbXGQA6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbXGQA6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:58:35 -0400
Received: from gw.goop.org ([64.81.55.164]:53982 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbXGQA6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:58:34 -0400
Message-ID: <469C13FE.6050606@goop.org>
Date: Mon, 16 Jul 2007 17:57:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [Xen-devel] [patch 03/44] usermodehelper: split setup from	execution
References: <20070716231536.937393000@xensource.com> >	  <20070716232912.409821000@xensource.com>> <1184632870.5955.26.camel@localhost.localdomain>
In-Reply-To: <1184632870.5955.26.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> The patch seems fine, but the names are awkward.  They've always been
> awkward (it's *userspace* helper, not *usermode* helper), but this just
> shines a bright light on them.
>
> So how about:
>
> 	call_usermodehelper_setup -> create_userspace_helper
> 	call_usermodehelper_<SET_EXTRA_STATE> -> userspace_helper_...
> 	call_usermodehelper_exec -> run_userspace_helper
>
> I can do that as a separate patch if you prefer (but it'd be nice to
> have it in the same merge window so the interface only churns once).

I don't have any particular objection, but I think it would be nicer if
they had a common prefix so that they're obviously related, and you can
easily infer the lifetime of the info structure.

    J
