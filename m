Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbXH3Mlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbXH3Mlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 08:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbXH3Mln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 08:41:43 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:47500 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbXH3Mlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 08:41:42 -0400
Date: Thu, 30 Aug 2007 13:40:25 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Roman Zippel <zippel@linux-m68k.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, kbuild-devel@lists.sourceforge.net
Subject: Re: CONFIG_HOTPLUG_CPU: kconfig bug?
In-Reply-To: <Pine.LNX.4.64.0708300235010.1817@scrub.home>
Message-ID: <Pine.LNX.4.64.0708301319590.32332@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708271525400.21853@blonde.wat.veritas.com>
 <20070827172654.GA21871@uranus.ravnborg.org> <Pine.LNX.4.64.0708272143150.29594@blonde.wat.veritas.com>
 <20070829180158.GA7849@uranus.ravnborg.org> <Pine.LNX.4.64.0708300235010.1817@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007, Roman Zippel wrote:
> 
> > > > > I've noticed an oddity with CONFIG_HOTPLUG_CPU in 2.6.23-rc:
> > > > > make oldconfig seems to turn it on even when nothing wants it,
> > > > > increasing kernel size by about 10k; but if you then edit the
> > > > > line out of .config and make oldconfig again, it correctly
> > > > > offers the choice and lets it be turned off after all.
> 
> It's somewhat a side effect of using select and defaults, the order of the 
> config symbols becomes significant for oldconfig, if you look at the 
> output you'll find:
> 
> Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL) (HOTPLUG_CPU) [Y/?] y
> 
> this sets it to 'y'. In this case one isn't asked about it, because there 
> is only one choice. The patch below avoids the setting of the value here.

Thanks for working that out: your patch certainly works for me,
and would be good to see in 2.6.23, to prevent lots of users getting
an unnecessary CONFIG_HOTPLUG_CPU forever after.  I wonder what config
options this might have forced in the past.

> 
> Avoid setting the value if the symbol doesn't need to be changed or can't 
> be changed. Later choices may change the dependencies and thus the 
> possible input range.
> 
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

But please add a sentence to your patch description, something like:

make oldconfig from a 2.6.22 .config with CONFIG_HOTPLUG_CPU not set
was in some configurations setting CONFIG_HOTPLUG_CPU=y without asking,
even when there was no actual requirement for CONFIG_HOTPLUG_CPU.

Thanks,
Hugh
