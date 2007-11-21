Return-Path: <linux-kernel-owner+w=401wt.eu-S1761235AbXKUK7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761235AbXKUK7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbXKUK7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:59:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:18983 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbXKUK7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:59:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JxtN/jmkmtCycvjVb2IlORCjI1zoFcC8wRldnx10tUl/KkdVuL4GTE2tOilCllpqhCxtfirpQsCQ1z44oXNfPBdi9rUqMsfb2qTHO570YBHrl9MFPZFMsK9c/ci/AA5trDI+AzWN89fI3nhBKnzXSeAkU3XauHmONp6ekqy0A2U=
Message-ID: <d9def9db0711210259v5d06590w7754aeb508632c77@mail.gmail.com>
Date: Wed, 21 Nov 2007 11:59:22 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: USB deadlock after resume
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       "Laurent Pinchart" <laurentp@cse-semaphore.com>
In-Reply-To: <d9def9db0711202132q2c5a9b46k79c00da68250db3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0711201347u2786fe0ev96b2fb43fc2954e9@mail.gmail.com>
	 <4743B160.7060007@rtr.ca>
	 <d9def9db0711202132q2c5a9b46k79c00da68250db3b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/07, Markus Rechberger <mrechberger@gmail.com> wrote:
> On 11/21/07, Mark Lord <lkml@rtr.ca> wrote:
> > Markus Rechberger wrote:
> > > Hi,
> > >
> > > I'm looking at the linux uvc driver, and noticed after resuming my
> > ..
> >
> > Pardon me.. what is the "uvc" driver?  Which module/source file is that?
> >
>
> http://linux-uvc.berlios.de/ it's not yet included in the kernel
> sources although many distributions already ship it.
> A "dry" run putting the device into sleep mode works fine (I added a
> proc interface for calling those suspend/resume function).
>

it's not just usb_set_interface that hangs actually.
It seems to hang at

wait_event(usb_kill_urb_queue, atomic_read(&urb->use_count) == 0);

in drivers/usb/core/urb.c after resuming. I disabled access to the usb
subsystem in the uvc driver, although connecting any other usb storage
fails too, just at the same point.

The hardware is:
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6
Family) USB UHCI #1 (rev 04) (8086:2658)

Markus
