Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZKHOYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZKHOYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 09:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbZKHOYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 09:24:37 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41893 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbZKHOYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 09:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k8OBP1O97bKZXCyXSZCYTh+UYb9K1rgwl/Mx6ZgZnF7kPdsw+yHZCYgTM9W+u2y9ja
         Wyb92mOvoUyWd4wXQOH9MncEVb28Hd/UA6nR95E6xVOhWkjp0lpucR1gYzF/26lk9cW9
         nyvG+2tQU5NuqXpJ1pEs+QMQgBS1sPgyWP6jU=
Date: Sun, 8 Nov 2009 22:25:06 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael A. Griffith" <grif@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Please get this committed, _NOW_ (preferrably 5 years
	ago), thanks.
Message-ID: <20091108142506.GA6240@hack>
References: <20091108120008.GA21611@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108120008.GA21611@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 01:00:08PM +0100, Andreas Mohr wrote:
>Hi guys,
>
>boy am I angry about this...
>
>When trying to get my ASUS WL-500gP v2 to boot (via the very nice
>OpenWrt infrastructure) from external media for a Debian-MIPSEL
>installation on it
>(see e.g. http://wpkg.org/Running_Debian_on_ASUS_WL-500G_deluxe ),
>I was hitting the dreaded "No init found." boot message.
>
>5 years (FIVE G*DDARN YEARS!! Leaving me wondering what Linux development
>has been doing all the time...) earlier I was in a diploma thesis project
>where I had the exact same issue, with the _exact same_ error message,
>which managed to waste the _exact same_ 2 or 3 hours that I managed to waste
>this time again (obviously my memory is not stellar enough to be able to
>recall that it was a console issue).
>I needed to search through a couple dozen forum threads (with many
>thread participants being helpless) to finally nail the issue I was having
>this time.
>
>Needless to say this error message is totally and deadly precisely
>UNHELPFUL, proof:
>Google "No init found." linux: 160000 results.
>Very conservative estimate: 5000 developers times 2 hours = 10000 hours
>of wasted precious developer time. An estimated lowly $50 per developer hour,
>thus a grand total of $500000 (FIVE HUNDRED THOUSAND AMERICAN DOLLARS, however
>broken the dollar might be at any moment in time ;) wasted
>on this unhelpfully implemented yet very critical (failure will leave you
>hanging dry in a hard place, with no immediate tools for remedy, with
>further unsuccessful image rebuilds taking > 30 minutes each)
>transition step.
>
>
>IMHO as catastrophic a failure in usability as it can ever get.
>
>
>Note that this patch hasn't even been compiled yet (the
>"See Linux " __FILE__ " for guidance." part might be the only thing to croak).
>I just wanted to get this out the door ASAP despite a tight time frame.
>You'll figure it out anyway ;)
>
>Useful ChangeLog phrase: provide crucial explanations for the dreaded
>"No init found." boot failure.
>
>Thanks,

Hi,

>
>Signed-off-by: Andreas Mohr <andi@lisas.de>
>
>
>--- linux-2.6.32-rc6/init/main.c.orig	2009-11-08 11:09:51.000000000 +0100
>+++ linux-2.6.32-rc6/init/main.c	2009-11-08 12:40:11.000000000 +0100
>@@ -846,7 +846,47 @@ static noinline int init_post(void)
> 	run_init_process("/bin/init");
> 	run_init_process("/bin/sh");
> 
>-	panic("No init found.  Try passing init= option to kernel.");
>+	panic("No init found.  Try passing init= option to kernel. "
>+    y          "See Linux " __FILE__ " for guidance.");


I would like to put those guidelines in a doc file, instead
of being a FAT comment in the source code.

And, you're explaining the _user space_ reasons that causes
this problem, not related with kernel at all.



>+/* ok, so you've got this pretty unintuitive message and are wondering
>+ * what the H*** went wrong.
>+ * Some high-level reasons for failure (listed roughly in order of execution)
>+ * to load the init binary are:
>+ * A) Unable to mount root FS
>+ * B) init binary doesn't exist on rootfs
>+ * C) other requirements not met
>+ * D) binary exists but dependencies not available
>+ * E) binary cannot be loaded
>+ *
>+ * Detailed explanations:
>+ * A) Please make sure you have the correct root FS type
>+ * (and root= in bootloader or CONFIG_CMDLINE points to the correct partition),
>+ * required drivers such as storage hardware (such as SCSI or USB!)
>+ * and filesystem (ext3, jffs2 etc.) are builtin (alternatively as modules by
>+ * using initrd)
>+ * C) Possibly a conflict in console= setup --> initial console unavailable.
>+ * E.g. some serial consoles are unreliable due to serial IRQ issues.
>+ * Try using a different console= device or e.g. netconsole=.
>+ * D) e.g. crucial library dependencies of the init binary such as
>+ * /lib/ld-linux.so.2 missing or broken. Use readelf -d <INIT>|grep NEEDED
>+ * to find out which libraries are required.
>+ * E) make sure the binary's architecture matches your hardware.
>+ * E.g. i386 vs. x86_64 mismatch, or trying to load x86 on ARM hardware.
>+ * Or did you try loading a non-binary file here!?! (shell script?)
>+ * To find out more, add patch here to display kernel_execve()s return values.
>+ *
>+ * Please extend this explanation whenever you find new failure causes
>+ * (after all loading the init binary is a CRITICAL and hard transition step
>+ * which needs to be made as painless as possible), then submit patch to LKML.
>+ * Further TODOs:
>+ * - Implement the various run_init_process() invocations via a struct array
>+ *   which can then store the kernel_execve() result value and on failure
>+ *   log it all by iterating over _all_ results (very important usability fix).
>+ * - try to make the implementation itself more helpful in general,
>+ *   e.g. by providing additional error messages at affected places.
>+ *
>+ * Andreas Mohr <andi at lisas period de>
>+ */
> }
> 
> static int __init kernel_init(void * unused)
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
