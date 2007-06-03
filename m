Return-Path: <linux-kernel-owner+w=401wt.eu-S1762503AbXFCLWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762503AbXFCLWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 07:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760799AbXFCLWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 07:22:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:30660 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139AbXFCLWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 07:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kn3qWOPRv19UUL6HGvflEN188UGM7CDaubPP6U0PAAyToX2tDcj82C9BS40Xkk6hyzLnxfiwH4DxhYuD2U0VftWiL03XYtAJURb58j3VBs0BrvP3yZdFspLV14me9fFh0iIB4ZA4k68746QrLI4E+q56rolcBXTxnp4gMxqa4R8=
Message-ID: <6278d2220706030422t7f249a8w144634949e3acdeb@mail.gmail.com>
Date: Sun, 3 Jun 2007 12:22:42 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Matt Fredrickson" <creslin@digium.com>
Subject: Re: Device Driver Etiquette
Cc: "Lee Revell" <rlrevell@joe-job.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, hpa@zytor.com
In-Reply-To: <15604445.159241180797166445.JavaMail.root@jupiler.digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12467610.159201180797054019.JavaMail.root@jupiler.digium.com>
	 <15604445.159241180797166445.JavaMail.root@jupiler.digium.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/07, Matt Fredrickson <creslin@digium.com> wrote:
> ----- "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
> > On 1 Jun, 19:40, "Lee Revell" <rlrevell@joe-job.com> wrote:
> > > On 6/1/07, Matthew Fredrickson <creslin@digium.com> wrote:
> > >
> > > > is it acceptable (although
> > > > not nice) to simply fix it this way, by disabling irqs while it
> > loads
> > > > the firmware?
> > >
> > > I would say to just disable IRQs while loading firmware.  Almost
> > every
> > > server I maintain has some vendor driver which generates a "many
> > lost
> > > ticks!" message on load.  As long as it's only done at module load
> > > time it should be fine.
> >
> > For anything ~10s or more, you'll probably also need to call the
> > timer
> > update function to prevent soft lockup warning being generated.
>
> Ahhh... so there is a way to get rid of that cursed message.  I forgot to mention this in my original message, the only place that I had seen this problem is on a certain machine (Dell 2950) with a certain distribution (FC6) kernel.  I had trimmed the code down to fit in 4K stacks already quite a bit.
>
> I believe what actually made it crash and overflow the stack (the straw that breaks the
> camels back, so to speak) was the intermittent triggering of the softlockup detector.
>  I think if I can disable that while the firmware is loading that will fix the stack overflow
> issues and correct my problem.

It may not help, since the NMIs used to detect soft lockups will still
be received; the soft lockup update call just updates the per-cpu
timer, but there may be less chance of overrunning the end of the
stack from not getting the stack trace.

There is no substitute for implementing your own firmware uploading
mechanism or getting this one addressed though ;-) .

Dan

> Matthew Fredrickson
-- 
Daniel J Blueman
