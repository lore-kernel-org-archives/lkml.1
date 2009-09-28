Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZI1Tou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZI1Tou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 15:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZI1Tot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 15:44:49 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:56119 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752707AbZI1Tot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 15:44:49 -0400
X-Sasl-enc: f4/oABbfh8F10ABg94cAcoLtC/AHUaHk1pactxw1an1A 1254167092
Date: Mon, 28 Sep 2009 16:44:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [origin tree build failure] [PATCH] thinkpad-acpi: Fix build
 on !CONFIG_THINKPAD_ACPI_HOTKEY_POLL
Message-ID: <20090928194449.GA9469@khazad-dum.debian.net>
References: <200909260519.n8Q5JrB6016778@hera.kernel.org>
 <20090927075254.GA20847@elte.hu>
 <20090927122828.GA24783@khazad-dum.debian.net>
 <alpine.LFD.2.00.0909272331520.5561@localhost.localdomain>
 <20090928153526.GA9231@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928153526.GA9231@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009, Ingo Molnar wrote:
> * Len Brown <lenb@kernel.org> wrote:
> > > > >  drivers/platform/x86/thinkpad_acpi.c    |  632 +++++++++++++++++++---------
> > > > 
> > > > -tip testing found that these changes caused a build failure 
> > > > in drivers/platform/x86/thinkpad_acpi.c when 
> > > > !CONFIG_THINKPAD_ACPI_HOTKEY_POLL - the fix is attached  below.
> > > 
> > > Fixed by a different patch, which will hit mainline soon....
> > 
> > Ingo,
> > 2.6.32-rc1 should build fine* -- let me know if it doesn't.
> > 
> > thanks,
> > Len Brown, Intel Open Source Technology Center
> > 
> > * module this message, which Henruque assures me will go away soon
> > drivers/platform/x86/thinkpad_acpi.c:2225: warning: 
> > ???tpacpi_hotkey_driver_mask_set??? defined but not used
> 
> well, the warning is fixed properly in my patch, as pointed out in the 
> changelog. Have you read that?

Your patch will break the driver when the functionality that uses
tpacpi_hotkey_driver_mask_set() lands in mainline.  That functionality is
already in a subsystem tree waiting a push to Linus.

Of course, you had no way to know that, and I failed to convey that detail
(mostly because _I_ screwed up and forgot I had that patch already applied)
when I replied to you.  Sorry about that.

The patch adding that functionality had already been submitted at the time
you sent in your patch, and it will be merged through the backlight tree
very soon.  That patch couldn't arrive earlier because it needed changes
both in the backlight tree AND in the ACPI tree, and nobody knew which tree
would merge first.

Now that all dependencies (both from backlight and ACPI) are already in
mainline, I asked Richard Purdie to send it to Linus together with his next
batch of backlight updates.  That will silence the warning about
tpacpi_hotkey_driver_mask_set().

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
