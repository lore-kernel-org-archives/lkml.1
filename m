Return-Path: <linux-kernel-owner+w=401wt.eu-S933679AbXHPQru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbXHPQru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763418AbXHPQrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:47:42 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:43492 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760408AbXHPQrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:47:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z92z9hN3wQMLjDe1QizGv/q5V4LMTfmSGyq841Q6vQsiTsZypS8L6dDZVq+u0nQIEY6uoMhDVsOqj7RGXQUHSxUmCIoM3iDEK60O8v3Dyd/qR8k0h3Qs+DhQEMc/Bp8s0tmsplszuLQXxwYqbqdKAGndx3JbMvo3HffhVL2cVsg=
Message-ID: <8bd0f97a0708160947x3bd308abmc4f3b523e2444586@mail.gmail.com>
Date: Thu, 16 Aug 2007 12:47:41 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Gerd Hoffmann" <kraxel@redhat.com>
Subject: Re: Early printk behaviour
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org
In-Reply-To: <46C4009F.9090206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708152234.06734.rgetz@blackfin.uclinux.org>
	 <46C4009F.9090206@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/16/07, Gerd Hoffmann <kraxel@redhat.com> wrote:
> Robin Getz wrote:
> > I was putting together an early printk implementation for the Blackfin, and
> > was wondering what the expected behaviour was in this situation.
> >
> > When I set up my bootargs earlyprintk=serial,ttyBF0,57600 and have no console
> > defined (no graphical console, no serial console).
> >
> > based on the patch:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69331af79cf29e26d1231152a172a1a10c2df511
> >
> > which no longer calls disable_early_printk, the earlyprintk console never gets
> > turned off (because nothing else ever calls register_console). I get
> > everything out the early console, until the init section is released (where
> > the console structure is sitting), and it starts printing out garbage.
> >
> > Is this expected behaviour?
>
> Hmm, sort of, although I didn't think about the case of no real console
> replacing the early console.  The intention of the patch is to have a
> smooth handover from the boot console to the real console.  And, yes, if
> no real console is ever registered the boot console keeps running ...

i think it also occurs in the case where real console != early console

> So you can either let it running and *not* mark it __init, so it can
> keep on going without breaking.  Or you can explicitly unregister your
> boot console at some point, maybe using a late_initcall.

wouldnt a common kernel late_initcall() be more appropriate ?  if
early console hasnt switched over (for whatever reason), then kill it
...
-mike
