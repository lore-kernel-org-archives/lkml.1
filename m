Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbXK2ROX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbXK2ROX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbXK2ROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:14:05 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:38682 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759877AbXK2ROC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:14:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=D9pg6vDmDN28nQ9b2dOKhSYWb1CbHsGUn3s8nJeODlF1oLx8kqV4cu8PTtJhZqWwIEuZ8QbOxoVRaUpo9+P0dKcFRZ24prq93/lag7bRXZTB9GXQ3PKT6n/Cf6i/gTbKY0d3WvpwADGBQ6L5CNAhPxKtF0JCkR5LxfzoH/hNeIA=
Message-ID: <3ae72650711290914q162e81a8l9fbecf1a1196ba79@mail.gmail.com>
Date: Thu, 29 Nov 2007 18:14:02 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: does /proc/sys/kernel/modprobe actually do anything?
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.9999.0711290756090.29674@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.9999.0711290438060.13461@localhost.localdomain>
	 <b6fcc0a0711290207jf82e618uccecf922a22c4f33@mail.gmail.com>
	 <alpine.LFD.0.9999.0711290756090.29674@localhost.localdomain>
X-Google-Sender-Auth: 9abb5e0f243e8e3e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 1:58 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> On Thu, 29 Nov 2007, Alexey Dobriyan wrote:
>
> > On 11/29/07, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> > > echo '#! /bin/sh' > /tmp/modprobe
> > > echo 'echo "$@" >> /tmp/modprobe.log' >> /tmp/modprobe
> > > echo 'exec /sbin/modprobe "$@"' >> /tmp/modprobe
> > > chmod a+x /tmp/modprobe
> > > echo /tmp/modprobe > /proc/sys/kernel/modprobe
> > >
> > >   i've tried that and i don't see that it does anything whatsoever.  i
> > > ran modprobe under "strace" and it doesn't appear to make any effort
> > > to check /proc/sys/kernel/modprobe.
> >
> > Kernel, not modprobe, checks /proc/sys/kernel/modprobe .
>
> actually, ignore that earlier query of mine, i've found the relevant
> code under kernel/ in sysctl.c and sysctl_check.c and kmod.c.  but
> it's still not clear why what is described in
> Documentation/debugging-modules.txt (and shown above) doesn't work, so
> i'm still open to suggestions.  thanks.

Kernel code can request a module to be loaded by calling request_module().
The /proc/sys/kernel/modprobe value is the path to the binary which the kernel
executes when this function is called. It is used by some modules, or if you
open an existing device node which has no actual driver loaded.

Most modules are loaded by device id's (modalias) of  a device.
The module is loaded by pure userspace tools and not by the kernel and
therefore /proc/sys/kernel/modprobe is not involved at all in most module
loading.

The text in Documentation/debugging-modules.txt is purely about kernel
module loading requests, and not helpful for the common module loading
case.

Kay
