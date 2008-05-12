Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbYELMAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbYELMAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 08:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbYELMAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 08:00:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:31596 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbYELMAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 08:00:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=THQV5a9D++vV/2AAPXPPRxl2ZVUo/5CfXvuf/KS2VkZGTXgEbB/kHSEYi4jrIsY/A3UnSHXA+sYJcdm9ia8TR5mxk3jLyr0Pr/wi3NLWs5WHIcyA6tK0VxOvo53PaPaEfjoV/tayyjJkVwY976mt+SlVOWv/1kIaaNjyn2SC+pA=
Message-ID: <19f34abd0805120500k7613dbd9le1bf79f7bb96778a@mail.gmail.com>
Date: Mon, 12 May 2008 14:00:07 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [RFC/PATCH] printk: detect incomplete lines
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Rob Landley" <rob@landley.net>
In-Reply-To: <84144f020805120456r14436eend416e079ea88be9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080512114925.GA29407@damson.getinternet.no>
	 <84144f020805120456r14436eend416e079ea88be9c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 1:56 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Mon, May 12, 2008 at 2:49 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>  >  This printk() problem has been bugging me for a long time. Consider the
>  >  following code:
>  >
>  >  diff --git a/init/main.c b/init/main.c
>  >  index ddada7a..777e02d 100644
>  >  --- a/init/main.c
>  >  +++ b/init/main.c
>  >  @@ -452,17 +452,38 @@ static void __init setup_command_line(char *command_line)
>  >   * gcc-3.4 accidentally inlines this function, so use noinline.
>  >   */
>  >
>  >  +static void printk_thread(const char *msg, unsigned long wait)
>  >  +{
>  >  +       int i = 0;
>  >  +
>  >  +       while(true) {
>  >  +               if (i == 0)
>  >  +                       printk(KERN_INFO "Here we go: ");
>  >  +
>  >  +               printk("%s%s", msg, i < 7 ? ", " : "\n");
>
>  You are supposed to use KERN_CONT here.

Uhm, no. KERN_CONT won't help at all, see include/linux/kernel.h:

/*
 * Annotation for a "continued" line of log printout (only done after a
 * line that had no enclosing \n). Only to be used by core/arch code
 * during early bootup (a continued line is not SMP-safe otherwise).
 */
#define KERN_CONT       ""

So even if I did, it would make no difference for the example :-)

Iirc, KERN_CONT is mostly an annotation for the checkpatch script to
suppress the warning about missing loglevel token.

(And let's face it, there are places in the kernel that have continued
lines even after early bootup.)

Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
