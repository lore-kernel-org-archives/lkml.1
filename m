Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbXEXSvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbXEXSvF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXEXSuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:50:54 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbXEXSux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:50:53 -0400
Date: Thu, 24 May 2007 11:49:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Cherwin R. Nooitmeer" <cherwin@gmail.com>,
       linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@bitplanet.net>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Marcus Better <marcus@better.se>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       linux-usb-devel@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2/3] 2.6.22-rc2: known regressions v2
Message-Id: <20070524114902.e802f327.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
References: <46558708.2040803@googlemail.com>
	<46559B54.80106@googlemail.com>
	<Pine.LNX.4.64.0705241001040.28086@schroedinger.engr.sgi.com>
	<alpine.LFD.0.98.0705241007290.26602@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 10:12:14 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > BUG: at include/linux/slub_def.h:88 kmalloc_index()
> 
> I'm going to change that "BUG:" to "WARNING:". 

I think we should remove these kmalloc(0, ...) warnings prior to
the 2.6.22 release, put them back afterwards.

Actually it would be useful to have some config variable which is "false"
for production kernels (2.6.x, 2.6.x.y) and "true" for development kernels
(2.6.x-rcN).  I suspect we'd end up using this in quite a lot of places for
general developer-nags which shouldn't be exposed to users of production
kernels.

The problem with this is that on the day Linus goes from 2.6.x-rc7 to 2.6.x
we suddenly get a compile-time kernel which nobody has tested, so we'd need
to set CONFIG_DEVELOPMENT_KERNEL to false around the -rc4/5 timeframe.

I'm not sure how we could do this, apart from patching and unpatching a
config file each time.
