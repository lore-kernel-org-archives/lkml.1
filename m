Return-Path: <linux-kernel-owner+w=401wt.eu-S933548AbXGRQAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548AbXGRQAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760121AbXGRQAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:00:43 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48681 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760061AbXGRQAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:00:42 -0400
Message-ID: <469E3907.5030708@s5r6.in-berlin.de>
Date: Wed, 18 Jul 2007 18:00:07 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-git* regression: Kconfig prompts without help text
References: <469BBDAD.2010908@s5r6.in-berlin.de> <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707181634100.5385@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Jul 16 2007 20:49, Stefan Richter wrote:
>>
>>It is an error to add visible Kconfig options without help text.  Among
>>them are the new "menuconfig" options.  Jan obviously never uses "make
>>oldconfig".
> 
> Untrue. Users of menuconfig/xconfig/gconfig who do not know what an
> item is supposed to do would not get any helptext either.

I mentioned 'make oldconfig' because there you can't get a preview of
what other options you are perhaps about to enable or disable.

> It's just that I did not quite know what helptext to put there
> besides some trivial "enable this to see more fluffy options from
> this category". Feel free to add Blame-From: <srichter> :)

Maybe I'm extraordinarily dumb, but I felt unable to determine for sure
what consequences enabling or disabling some of those new prompts had
when I ran 'make oldconfig' for the first time in a post-2.6.22 tree.

Will saying Y merely present further options, or will it actually cause
something to be built?

> But see below.
> 
>>Most of these options were added after 2.6.22:
>>
>>BLK_DEV
>>HID_SUPPORT
>>INSTRUMENTATION
>>MACINTOSH_DRIVERS
>>MISC_DEVICES
>>USB_SUPPORT
>>
>>Here are suggestions for help texts.  Please verify if they are correct
>>and check whether there are more new (menuconfig) options without help
>>texts.
> 
> Other config options without text include:
> 
> CRYPTO_HW       (b511431d85948823ec58639bd3137b910964be34)
> AUXDISPLAY      (f5920969fb9e29c9d60568864d0a56fe85e8f4b6)
> VIRTUALIZATION  (de062065a5293d8f434acb2d6ba5df87ad76bbd9)
> ATM_DRIVERS     (4151ce3159c18a990da7fd6f0fe36c73d1c40f87)
> NETDEV_1000     (f30486d57bceec2364aa696403d64429ada61b60)
> NETDEV_10000    (f30486d57bceec2364aa696403d64429ada61b60)
> 
> Thanks for the starting help texts. I have produced a cumulative patch
> with both yours and the extra ones listed above.

Thanks for making an actual patch out of it and adding these other bits.

> Can we somehow sneak
> this directly in without split-to-maintainers? tis' just some help text.
> (Patch below)
> 
>>PS:
>>
>>I believe one possible *bug* of this menuconfig stuff is that if (1.)
>>user X disables menuconfig A in linux-2.6.x because nothing interesting
>>for him is in there, (2.) developer Y adds something very interesting in
>>menu A in linux-2.6.x+1, --> (3.) user X will miss this new option when
>>he runs "make oldconfig" when switching to linux-2.6.x+1 because
>>everything between 'if A'...'endif # A' will be invisible and disabled.
> 
> If I once said "I don't want no USB", I do not want to be prompted in a later
> version for USB_COFFEE_PAD. :)

Sure, if I disable USB now I expect that I may possibly miss
USB_COFFEE_PAD in 2.6.47.  That wouldn't worry me.

But what about loosely defined categories like BLK_DEV, INSTRUMENTATION,
MISC_DEVICES?  What functionality will be provided by their suboptions
in 2.6.47?
-- 
Stefan Richter
-=====-=-=== -=== =--=-
http://arcgraph.de/sr/
