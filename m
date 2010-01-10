Return-Path: <linux-kernel-owner+w=401wt.eu-S1752186Ab0AJIJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0AJIJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 03:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047Ab0AJIJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 03:09:45 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37622 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab0AJIJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 03:09:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fFqhNfv6u1tkV9qooZcM6VzfviV5kokvUik9LdIQ2qeX6Pl+iCU3GDLMPsMbIObff/
         ulWSFiuAUs6KO6tJtQasiJi6ul0CtTH2xV/KFAL9p50bNwJ+2GL6uhXhMo4gAARingr5
         e8t7Rqh+j9iaJQ2iv5Q6Nl5ayr+jdzO+CPCTw=
Date: Sun, 10 Jan 2010 11:09:40 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Brian Gerst <brgerst@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
	tables
Message-ID: <20100110080940.GB5189@lenovo>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org> <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de> <20100106112133.GA5815@lenovo> <alpine.DEB.2.01.1001060434330.3483@bogon.housecafe.de> <4B4633D3.2070903@zytor.com> <alpine.DEB.2.01.1001071123220.3483@bogon.housecafe.de> <20100108215039.GD4967@lenovo> <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73c1f2161001091750y67a852dfk7539021dcc82fa1f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 09, 2010 at 08:50:04PM -0500, Brian Gerst wrote:
...
> > ---
> > x86: kernel_thread -- initialize SS to a known state
> >
> > Before the kernel_thread was converted into "C" we had
> > pt_regs::ss set to __KERNEL_DS (by SAVE_ALL asm macro).
> >
> > Though I must admit I didn't find any *explicit* load of
> > %ss from this structure the better to be on a safe side
> > and set it to a known value.
> 
> It shouldn't make any difference, but maybe Xen is doing something
> subtle.  In 64-bit mode the %ss segment register is supposed to be
> ignored, which is why it is left set to zero.  It works properly on
> real hardware.  It can't hurt anything to put __KERNEL_DS back in, but
> I'd just like to know why Xen requires it if this does fix it.

Yeah, I didn't found any explicit %ss reloading for this _particular_
case (as I marked in patch changelog). So the only suspicious is Xen
itself. So as only Christian get ability to test -- we will see the
results.

> 
> --
> Brian Gerst
> 
	-- Cyrill
