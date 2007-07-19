Return-Path: <linux-kernel-owner+w=401wt.eu-S933572AbXGSDeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572AbXGSDeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 23:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758209AbXGSDeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 23:34:03 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:16962 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113AbXGSDeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 23:34:02 -0400
X-IronPort-AV: i="4.16,553,1175486400"; 
   d="scan'208"; a="35202988:sNHT25602738"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: early_printk accessing __log_buf
Date: Wed, 18 Jul 2007 23:37:34 -0400
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200707181756.44074.rgetz@blackfin.uclinux.org> <200707181939.46910.rgetz@blackfin.uclinux.org> <8bd0f97a0707181653j3d44aab2tf8b6d24689458023@mail.gmail.com>
In-Reply-To: <8bd0f97a0707181653j3d44aab2tf8b6d24689458023@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707182337.34767.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 19 Jul 2007 03:33:59.0631 (UTC) FILETIME=[A4E875F0:01C7C9B5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18 Jul 2007 19:53, Mike Frysinger pondered:
> On 7/18/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > On Wed 18 Jul 2007 18:16, Andrew Morton pondered:
> > > I'd suggest that any interface into here should be via function calls,
> > > not via direct access to printk internals: think up some nice
> > > copy_me_some_of_the_log_buffer() interface.
> >
> > If so - I would still like to put it in:
> >  - ifdef CONFIG_EARLY_PRINTK
> >  - and define as __init
> >
> > so that people don't use it when they shouldn't (when the kernel is up an
> > running).
> >
> > Something simple like - early_copy_log_buff(void *dest, size_t n)
> >
> > copies n bytes from log_buf to memory area dest. Returns number of bytes that
> > could not be copied. Can find out how many bytes are in the log_buff by
> > calling with zero size.
> >
> > This is not destructive to existing interfaces (log_start and con_start are
> > not updated/used). This should ensure that if booting does work - that normal
> > messages come out the standard method.
> >
> > Any other suggestions?
> 
> maybe something as cheesy as early_get_log_buf() ?  that way you dont
> have to do any buffer management, you can just operate read-only on
> the string ...

I actually thought I might just do something like:

  char *c;
  while (early_copy_log_buff(c, 1))
	out_early_serial_byte(c);

that way - I don't need to be very complex in the arch code.

That is about as cheesy/easy as I could think of...

-Robin
