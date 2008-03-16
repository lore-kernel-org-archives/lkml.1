Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYCPT3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYCPT3h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYCPT3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:29:30 -0400
Received: from tim.rpsys.net ([194.106.48.114]:40688 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYCPT33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:29:29 -0400
Subject: Re: [GIT PULL] LED updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080316181840.GG19825@khazad-dum.debian.net>
References: <1202380503.9519.21.camel@dax.rpnet.com>
	 <20080207213845.GA27862@khazad-dum.debian.net>
	 <1202422388.9519.123.camel@dax.rpnet.com>
	 <20080316181840.GG19825@khazad-dum.debian.net>
Content-Type: text/plain
Date: Sun, 16 Mar 2008 19:29:16 +0000
Message-Id: <1205695756.4524.20.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-03-16 at 15:18 -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 07 Feb 2008, Richard Purdie wrote:
> > > This one causes trouble (at least on 2.6.23 -- I backported the patch) due
> > > to the 20-byte length limit on sysfs names.  I had to use "tp::<somecrap>"
> > > instead of "thinkpad::<somecrap>" to name LEDs, and still had to reduce
> > > ultrabase_battery to ultrabase_batt :-)
> > > 
> > > Anyway, IMHO, the LED function should come first, and we should not even
> > > need the led driver name anywhere.  In case of clashes in the class sysfs
> > > dir, just tack a .# to the end or somesuch.  The device the LED is tied to
> > > already differentiates them.  That would save a lot of chars for something
> > > much more useful (the function).
> > 
> > Ouch, I'm looking into this. I wish I'd known about it earlier. I agree
> > function is more important but didn't want to break the existing
> > convention. I guess this limitation comes from the kobjects involved...
> 
> Richard, any ideas for that?  It *is* still time to change this for 2.6.25,
> if required.  If you changed it once already, changing it again won't cause
> further damage.
> 
> I need to know if the current naming scheme will hold or not, I do NOT want
> an ABI issue on thinkpad-acpi, and I know for a fact at least Debian will
> want to use the thinkpad-acpi LED interface as soon as I deploy it.  I want
> to send the thinkpad-acpi LED interface patches to the users as soon as
> possible.
> 
> Sincerely?  I think you should make it <function>:[color][.instance] and
> drop device name compleley, ASAP.
> 
> I will write the patches for mainline and your for-mm branch, if that would
> speed up things.  But I need to know what you have decided, first.

As I understand it 2.6.26 will lose the limitation on the name size
entirely so the problem will go away soon. I don't want to change the
existing ABI so changing to what you describe above isn't possible. You
could leave the devicename empty if you wish although I'd prefer you not
to. Keeping it short might be the best option for 2.6.25.

Your other patch looks ok btw although I'm not sure why you sent it
twice. I'll queue that tomorrow.

Cheers,

Richard

