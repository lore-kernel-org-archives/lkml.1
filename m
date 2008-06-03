Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYFCQ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYFCQ4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYFCQ4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:56:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbYFCQ4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:56:06 -0400
Date: Tue, 3 Jun 2008 18:56:37 +0200
From: Olaf Dabrunz <od@suse.de>
To: Jon Masters <jcm@redhat.com>
Cc: Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Stefan Assmann <sassmann@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
Message-ID: <20080603165637.GD16200@suse.de>
Mail-Followup-To: Jon Masters <jcm@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>, Stefan Assmann <sassmann@suse.de>,
	linux-kernel@vger.kernel.org
References: <12124107071847-git-send-email-od@suse.de> <1212508321.22357.13.camel@londonpacket.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1212508321.22357.13.camel@londonpacket.bos.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-Jun-08, Jon Masters wrote:
> I like the patch series, insomuch as the intention is good, and it does
> away with the special PCI IRQ quirk patches some of us are carrying in
> our vendor trees to temporarily workaround this problem[0]. Also, I'm
> extremely impressed with the research that went into this, since I
> repeatedly tried to get ahold of information about disabling this
> unfortunate "feature" of various bridges, without much success.

Thanks a lot. :)

BTW, your blog was really helpful to get up to speed on this again. :)
(I read about (RT) IRQ problems a looong time ago on lkml... ;))

We also looked through the code and added tests to make sure that
IRQ-handling works correctly and to test a few theories. We became
relatively convinced that the code was correct. Then we thought the
failures were too systematic to be caused by glitches. Always the same
IRQs were triggered, and only when the "original" ones were masked.

We found first answers in the i6700PXH datasheet. After the first
reroute patch worked, the rest was about finding similar answers for
other chipsets.

> However, I really am not happy with the implementation as it stands. The
> duplicated table of quirks that doesn't really fit in with the existing
> PCI quirks infrastructure, the weird naming of the kernel options, and
> various other things that Thomas has already mentioned in his reply.
> Therefore, I think this needs a bit more reworking before going in.

Yep. We are working on it. Thanks for your comments. :)

> Thanks!
> 
> Jon.
> 
> [0] The real fix come when we move IRQ handling in RT to per-device
> threads, as is the longer term intention. Then you can quiesse the
> device immediately and not the mask/unmask cycle that fails here.

Yes, per-device threads help with the latency. I believe the boot irq
patches here can then make drivers work that do not (yet) use the new
approach. Also, I am not sure so far whether all devices can quiesce
their IRQs on the device without introducing possible loss of IRQs --
but that is just theory (or FUD? BS? oh-oh *duck*), so please don't
mind... :}

Thanks,

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

