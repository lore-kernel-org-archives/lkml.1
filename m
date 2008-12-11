Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYLKRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYLKRog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbYLKRoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:44:15 -0500
Received: from kroah.org ([198.145.64.141]:44323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756740AbYLKRoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:44:12 -0500
Date: Thu, 11 Dec 2008 08:44:54 -0800
From: Greg KH <greg@kroah.com>
To: Roland McGrath <roland@redhat.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Ulrich Weigand <ulrich.weigand@de.ibm.com>, Oleg Nesterov" 
	<oleg@tv-sign.ru>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       stable@kernel.org
Subject: Re: [stable] [PATCH] tracehook: exec double-reporting fix
Message-ID: <20081211164454.GD15057@kroah.com>
References: <200812091533.10628.arnd@arndb.de> <20081210040423.5EE72FC362@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210040423.5EE72FC362@magilla.sf.frob.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09, 2008 at 08:04:23PM -0800, Roland McGrath wrote:
> The following changes since commit 437f2f91d6597c67662f847d9ed4c99cb3c440cd:
>   Linus Torvalds (1):
>         Merge master.kernel.org:/home/rmk/linux-2.6-arm
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-roland.git to-linus
> 
> Roland McGrath (1):
>       tracehook: exec double-reporting fix
> 
>  fs/exec.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> 
> Thanks,
> Roland
> ---
> [PATCH] tracehook: exec double-reporting fix
> 
> The patch 6341c39 "tracehook: exec" introduced a small regression in
> 2.6.27 regarding binfmt_misc exec event reporting.  Since the reporting
> is now done in the common search_binary_handler() function, an exec
> of a misc binary will result in two (or possibly multiple) exec events
> being reported, instead of just a single one, because the misc handler
> contains a recursive call to search_binary_handler.

<snip>

Unfortunatly, bprm->recursion_depth was added in 2.6.28-rc1, so this
patch can't easily apply to the 2.6.27.y tree :(

Should I also apply commit id bf2a9a39639b8b51377905397a5005f444e9a892:
	From: Kirill A. Shutemov <kirill@shutemov.name>
	Date: Wed, 15 Oct 2008 22:02:39 -0700
	Subject: [PATCH] Allow recursion in binfmt_script and binfmt_misc

To get this one to apply properly?

Hm, in looking at bf2a9a39639b8b51377905397a5005f444e9a892, that seems
like a valid fix for the 2.6.27.y series as well, so perhaps I should do
this anyway.

Any objections to that?

thanks,

greg k-h
