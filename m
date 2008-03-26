Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbYCZVEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbYCZVEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbYCZVEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:04:25 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:32374 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbYCZVEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KzECZIhhXaYzJUSyboKBsnAru+VCjqLGIrdNbfUuScQ3AJe7MhZs4D8qv8gKEeIJF27CkkdLz+hdhunIumpX8tHVLGq6sZnlGIMHpmtMcA3avoCayJPbIOimyYyCkphLZ1RYCEaqV9sARKZC9iUonF8ZhtB7Tz95tCwebhLEhEI=
Message-ID: <9a8748490803261404u2ef0f6f0rf4cccc2602cca726@mail.gmail.com>
Date: Wed, 26 Mar 2008 22:04:21 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Ben Castricum" <lk08@bencastricum.nl>
Subject: Re: [TRIVIAL PATCH] Microcode: show results on success too plus fix typo
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080326134053.c75656dc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <001701c88f7f$1e2b6c80$0602a8c0@links>
	 <20080326134053.c75656dc.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/2008, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Wed, 26 Mar 2008 21:22:25 +0100 Ben Castricum wrote:
>
>  > Show a bit more info when updating microcode. It used to be there but
>  > no with DEBUG unset makes it very silent.
>  >
>  > This is my first patch, please let me know if I did anything wrong.
>  >
>  > Signed-off-by: Ben Castricum <lk08@bencastricum.nl>

A line with "---" after Signed-off-by: is prefered.

A diffstat is also common.

To quote Documentation/SubmittingPatches :
"The canonical patch message body contains the following:

  - A "from" line specifying the patch author.

  - An empty line.

  - The body of the explanation, which will be copied to the
    permanent changelog to describe this patch.

  - The "Signed-off-by:" lines, described above, which will
    also go in the changelog.

  - A marker line containing simply "---".

  - Any additional comments not suitable for the changelog.

  - The actual patch (diff output).
"

>  >
>  > diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
>  > index f2702d0..ca1fd52 100644
>  > --- a/arch/x86/kernel/microcode.c
>  > +++ b/arch/x86/kernel/microcode.c
>  > @@ -336,11 +336,11 @@ static void apply_microcode(int cpu)
>  >
>  >   spin_unlock_irqrestore(&microcode_update_lock, flags);
>  >   if (val[1] != uci->mc->hdr.rev) {
>  > -  printk(KERN_ERR "microcode: CPU%d updated from revision "
>  > +  printk(KERN_ERR "microcode: CPU%d update from revision "
>  >     "0x%x to 0x%x failed\n", cpu_num, uci->rev, val[1]);
>  >    return;
>  >   }
>  > - pr_debug("microcode: CPU%d updated from revision "
>  > + printk(KERN_INFO "microcode: CPU%d updated from revision "
>  >          "0x%x to 0x%x, date = %08x \n",
>  >          cpu_num, uci->rev, val[1], uci->mc->hdr.date);
>  >   uci->rev = val[1];
>
>
> Your mailer client (*cough*) converted tabs to spaces,
>  so the patch does not apply cleanly now.
>  You'll need to find a way to send patches that does not mangle
>  whitespace.
>

Also, since this is a rather trivial patch (even hinted at in the
subject) you should probably have added trivial@kernel.org to Cc: - if
you don't, the chances that I will notice it and pick it up in the
trivial tree are pretty slim.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
