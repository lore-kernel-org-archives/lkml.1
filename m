Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbYBEXOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbYBEXOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbYBEXOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:14:40 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34371 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbYBEXOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:14:39 -0500
References: <20080125180232.GA4613@kroah.com>
            <20080202123710.42df1aa0@weinigel.se>
            <20080202191930.GA19826@kroah.com>
            <20080203124849.0226560f@weinigel.se>
            <84144f020802030635h3a9c4304n943d117e936f1c2d@mail.gmail.com>
            <47A5F418.6030104@weinigel.se>
            <20080203231530.GB15692@kroah.com>
In-Reply-To: <20080203231530.GB15692@kroah.com>
From: David Newall <davidn@davidnewall.com>
To: Greg KH <greg@kroah.com>
Cc: Christer Weinigel <christer@weinigel.se>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Date: Wed, 06 Feb 2008 09:44:36 +1030
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <courier.47A8EDDC.0000785F@hawking.rebel.net.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH writes:
> No, it really is not a gray area at all, especially when you are writing
> a new driver for Linux.  Go talk to a lawyer if you want the details.

If we're still talking about whether a kernel module is required to be 
released under GPL, then yes, this is not a gray area.  This is something 
that authors of original works can decide for themselves.  They have no 
obligation to release under GPL, however they must take special care to 
ensure that the module does not (statically) link with the kernel.  Richard 
Stallman (apparently, according to Pavel Roskin, although he didn't forward 
Richard's message as requested) said it nicely: 

According to Pavel Roskin, Richard Stallman said:
> It is not in general the case that "dynamic linking cannot violate the
> GPL".  It depends on circumstances.  Running a non-free program in a
> process in a GNU/Linux system is not linking of any kind with Linux.
> The program probably links with GNU libc, but the license of GNU libc
> permits that.

A kernel module is akin to a process.  It uses services of the kernel 
without being part of the kernel.  However in order to use the kernel it 
might very well statically link with kernel support functions, such as 
copy_from_user().  This, it may not do without garnering a requirement to be 
released under GPL.  That being said, a module can be written such that it 
only dynamically links with the kernel.  Ndiswrapper is an example of how 
this can be done: None of the drivers that work under ndiswrapper make any 
direct use of the kernel, not in any way, indeed a wrapper could be written 
for a different operating system.  There is no obligation for ndis drivers 
to be released under GPL, and even though they are not, they break no 
licence condition by calling services, even those exported as GPL-only. 

Bringing this back to the point, the notion that some exported symbols may 
be accessed by proprietary modules and others can't is wrong.  The licence 
under which Linux is released makes no mention of this possibility, and so 
no such condition exists.  In order to prevent proprietary modules from 
using a symbol, that symbol must be provided in such a way that a second 
module can only statically link to it.  I think that precludes exporting it 
via EXPORT_SYMBOL or EXPORT_SYMBOL_GPL. 

Summarising the point: To claim all USB drivers must be released under GPL 
is wrong.
