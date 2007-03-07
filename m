Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXCGP4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXCGP4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbXCGP4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:56:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38836 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751954AbXCGP4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:56:02 -0500
Date: Wed, 7 Mar 2007 17:00:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] prism54usb: Fix hail of warnings on 64bit platforms
Message-ID: <20070307170018.61f36a0f@lxorguk.ukuu.org.uk>
In-Reply-To: <45EEDD81.4080301@rtr.ca>
References: <20070307164020.16944e32@lxorguk.ukuu.org.uk>
	<45EEDD81.4080301@rtr.ca>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 10:42:57 -0500
Mark Lord <lkml@rtr.ca> wrote:

> Alan Cox wrote:
> > If you want to cast a pointer to a small value then start by turning it
> > into an unsigned long so the compiler knows what is going on.
> > 
> > Personally I find the whole approach used by this driver for types of
> > registers (which are really USB register numbers) utterly perverse...
> ...
> >
> >	err = p54u_write(priv, buf, type,\
> > -				 cpu_to_le32((u32)addr), data);\
> > +				 cpu_to_le32((u32)(unsigned long)addr), data);\
> ...
> 
> What exactly are those "addr" parameters -- memory addresses ?
>

They end up being passed as small values over the USB link to the chip
the other end. 

Alan
