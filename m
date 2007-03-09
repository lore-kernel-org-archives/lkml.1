Return-Path: <linux-kernel-owner+w=401wt.eu-S1767487AbXCIU3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767487AbXCIU3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933380AbXCIU3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:29:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:5460 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226AbXCIU3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:29:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=W3QLqYX4jun4og0ErAQ33ZDBpvU/+3Mi6lhBbJPSbk1R+Aa9VX18F8/6VEMebNxBjJlhng58qp5SWknAUU6VKZvgd3Bgc2MOALxC0hCky/wynP5pZb3hDSBw4a7bAhFxWtFfmP+Pu3yx+1WWSgFwtjlc7QSXbqZUyrtE6Px2itw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2.6.22] remove Intel combined mode quirk
Date: Fri, 9 Mar 2007 21:36:28 +0100
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070309160127.GA10226@havoc.gtf.org>
In-Reply-To: <20070309160127.GA10226@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703092136.28535.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 09 March 2007, Jeff Garzik wrote:
> 
> Discussed for 2.6.21, but pushed back because the current SATA code
> had enough fun stuff to debug already.  Thus, just queued the following
> for 2.6.22 in libata-dev.git#upstream.
> 
> The nasty ____request_resource hack is finally gone.
> 
> In practical terms, this usually means that some combined mode users
> will have their SATA devices driven by the old-IDE driver rather than
> libata (because old-IDE is often non-modular, and thus probes first).
> 
> But really, these same users will IMO cheer the removal of the
> performance-killing split-driver configuration, so its a net win.
> And the code is smaller and more clean, with one less special case
> hack.
> 
>     libata/IDE: remove combined mode quirk
>     
>     Both old-IDE and libata should be able handle all controllers and
>     devices found using normal resource reservation methods.
>     
>     This eliminates the awful, low-performing split-driver configuration
>     where old-IDE drove the PATA portion of a PCI device, in PIO-only mode,
>     and libata drove the SATA portion of the /same/ PCI device, in DMA mode.
>     Typically vendors would ship SATA hard drive / PATA optical
>     configuration, which would lend itself to slow (PIO-only) CD-ROM
>     performance.
>     
>     For Intel users running in combined mode, it is now wholly dependent on
>     your driver choice (potentially link order, if you compile both drivers
>     in) whether old-IDE or libata will drive your hardware.
>     
>     In either case, you will get full performance from both SATA and PATA
>     ports now, without having to pass a kernel command line parameter.
>     
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Thanks for fixing this.

Bart
