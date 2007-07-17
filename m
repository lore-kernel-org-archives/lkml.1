Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbXGQAlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbXGQAlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 20:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbXGQAlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 20:41:46 -0400
Received: from ozlabs.org ([203.10.76.45]:59382 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbXGQAlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 20:41:46 -0400
Subject: Re: [Xen-devel] [patch 03/44] usermodehelper: split setup from
	execution
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Linus Torvalds <torvalds@linux-foundation.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.com>
In-Reply-To: <20070716232912.409821000@xensource.com>>
References: <20070716231536.937393000@xensource.com> >
	  <20070716232912.409821000@xensource.com>>
Content-Type: text/plain
Date: Tue, 17 Jul 2007 10:41:10 +1000
Message-Id: <1184632870.5955.26.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-16 at 16:15 -0700, Jeremy Fitzhardinge wrote:
> plain text document attachment (usermodehelper-split-init.patch)
> Rather than having hundreds of variations of call_usermodehelper for
> various pieces of usermode state which could be set up, split the
> info allocation and initialization from the actual process execution.
> 
> This means the general pattern becomes:
>  info = call_usermodehelper_setup(path, argv, envp); /* basic state */
>  call_usermodehelper_<SET EXTRA STATE>(info, stuff...);	/* extra state */
>  call_usermodehelper_exec(info, wait);	/* run process and free info */

The patch seems fine, but the names are awkward.  They've always been
awkward (it's *userspace* helper, not *usermode* helper), but this just
shines a bright light on them.

So how about:

	call_usermodehelper_setup -> create_userspace_helper
	call_usermodehelper_<SET_EXTRA_STATE> -> userspace_helper_...
	call_usermodehelper_exec -> run_userspace_helper

I can do that as a separate patch if you prefer (but it'd be nice to
have it in the same merge window so the interface only churns once).

Rusty.

