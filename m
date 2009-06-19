Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbZFSUNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbZFSUNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbZFSUNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:13:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZFSUNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:13:08 -0400
Subject: Re: [PATCH] Add new TAINT_KSPLICE flag for when a Ksplice update
 has been loaded.
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Kaseorg <andersk@ksplice.com>,
       Jeffrey B Arnold <jbarnold@ksplice.com>
In-Reply-To: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 22:11:47 +0200
Message-Id: <1245442307.16209.66.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-19 at 15:57 -0400, Tim Abbott wrote:
> Distributions and kerneloops.org have requested that the Ksplice
> rebootless update system taint the kernel the first time that a
> Ksplice update is installed, in order to assist with bug triage.
> 
> Ksplice uses a new taint flag, TAINT_KSPLICE, displayed as 'K', for
> this purpose.
> 
> We would like to confirm that this use of taint meets with the
> community's approval and get this taint flag registered in mainline.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>

Since all of ksplice is still out-of-tree, it seems to me this taint
should be too.

Just add it to the ksplice patch. That way it will get into mainline
if/when ksplice will.

> ---
>  include/linux/kernel.h |    1 +
>  kernel/panic.c         |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index c5a71c3..be77585 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -330,6 +330,7 @@ extern enum system_states {
>  #define TAINT_OVERRIDDEN_ACPI_TABLE	8
>  #define TAINT_WARN			9
>  #define TAINT_CRAP			10
> +#define TAINT_KSPLICE			11
>  
>  extern void dump_stack(void) __cold;
>  
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 984b3ec..c2ea780 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -160,6 +160,7 @@ static const struct tnt tnts[] = {
>  	{ TAINT_OVERRIDDEN_ACPI_TABLE,	'A', ' ' },
>  	{ TAINT_WARN,			'W', ' ' },
>  	{ TAINT_CRAP,			'C', ' ' },
> +	{ TAINT_KSPLICE,		'K', ' ' },
>  };
>  
>  /**
> @@ -176,6 +177,7 @@ static const struct tnt tnts[] = {
>   *  'A' - ACPI table overridden.
>   *  'W' - Taint on warning.
>   *  'C' - modules from drivers/staging are loaded.
> + *  'K' - A Ksplice update has been loaded.
>   *
>   *	The string is overwritten by the next call to print_taint().
>   */

