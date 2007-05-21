Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbXEUQ4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbXEUQ4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 12:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbXEUQz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 12:55:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:50333 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755722AbXEUQz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 12:55:56 -0400
X-Authenticated: #8359428
X-Provags-ID: V01U2FsdGVkX1+kzrFgQa2kkpW2ARNmZwpllNytBnB3AocuNvwj0K
	mppkg/T3D+Nn9K
From: Uwe Bugla <uwe.bugla@gmx.de>
To: "Ken Chen" <kenchen@google.com>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Mon, 21 May 2007 18:50:59 +0200
User-Agent: KMail/1.9.5
References: <464F42F3.1080300@madrabbit.org> <b040c32a0705210927q24e2cd8fm9f4616941fccfdea@mail.gmail.com> <b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com>
In-Reply-To: <b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com>
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211851.00187.uwe.bugla@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 21. Mai 2007 18:37 schrieben Sie:
> On 5/21/07, Ken Chen <kenchen@google.com> wrote:
> > yes and no. in that commit, I automatically create n+1 device when
> > loop device n is created, allergically was tested to be fine with
> > casual usage of "losetup" and "mount -o loop".  However, there is a
> > bug in that commit when loop.c was compiled as a module.  And when Al
> > fixed it, he also removed that magic "n+1" trick.
> >
> > Nevertheless, yes, I'm guilty of introducing the new behavior.
>
> The easiest way is to reinstate max_loop and create "max_loop" device
> up front at module load time.  However, that will lose all the "fancy
> on-demand device instantiation feature".
>
> So I propose we do the following:
>
> 1. have the module honor "max_loop" parameter and create that many
> device upfront on module load (max_loop will also be a hard max) iff
> user specify the parameter.
> 2. if max_loop is not specified, default create 8 loop device.  User
> can extent more loop device by create device node themselves and have
> kernel automatically instantiate loop device on-demand.

Sorry, Ken:
My question on point 2 would be: Does "User can extent more loop device by 
create device node themselves and......." correspond or conflict to working 
with udev?

>
> Is this acceptable?  Patch in a bit.
