Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab0BCXsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:48:09 -0500
Received: from leo.clearchain.com ([199.73.29.74]:49973 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab0BCXsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:48:06 -0500
Date: Thu, 4 Feb 2010 09:45:28 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for eGalax Touchcontroller
Message-ID: <20100203234528.GC5550@barra.bne.redhat.com>
References: <20100202034040.GA16880@barra.bne.redhat.com>
 <alpine.LNX.2.00.1002022129380.15395@pobox.suse.cz>
 <20100203033914.GA23850@barra.bne.redhat.com>
 <alpine.LNX.2.00.1002031152370.15395@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1002031152370.15395@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Thu, 04 Feb 2010 10:18:00 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 11:53:20AM +0100, Jiri Kosina wrote:
> On Wed, 3 Feb 2010, Peter Hutterer wrote:
> 
> > > Does looking at the HID report descriptor and looking at the actual 
> > > raw HID reports coming out from the device give any clue? (in recent 
> > > kernels, you can just use 'hid' directory in debugfs to gather all 
> > > this information).
> > 
> > Thanks. The hid descriptor table is attached, but tbh I'm not well-versed
> > enough in the HID protocol to even tell what format I can give you. I've
> > attached a simple hexdump of two presses, one with a finger, one with the
> > stylus. Let me know what format you need or what how I can start to decypher
> > this myself (are there any parsing tools around?).
> 
> It shouldn't be necesarry to run hexdump on the 'events' node, the data 
> coming from it are supposed to already be parsed and human-readable.

aah, don't we love a good brown paper bag moment...

events are below, if I read this correctly the hardware might need a quirk
for the permanently-set InRange bits.

report (size 6) (numbered)
report 2 (size 6) =  02 03 69 0e c4 03
Digitizers.TipSwitch = 1
Digitizers.InRange = 1
GenericDesktop.X = 3689
GenericDesktop.Y = 964

report (size 6) (numbered)
report 2 (size 6) =  02 03 6f 0e bb 03
Digitizers.TipSwitch = 1
Digitizers.InRange = 1
GenericDesktop.X = 3695
GenericDesktop.Y = 955

[...]

report (size 6) (numbered)
report 2 (size 6) =  02 02 71 0e a9 03
Digitizers.TipSwitch = 0
Digitizers.InRange = 1
GenericDesktop.X = 3697
GenericDesktop.Y = 937

report (size 6) (numbered)
report 2 (size 6) =  02 03 68 0e d1 03
Digitizers.TipSwitch = 1
Digitizers.InRange = 1
GenericDesktop.X = 3688
GenericDesktop.Y = 977

report (size 6) (numbered)
report 2 (size 6) =  02 03 67 0e d1 03
Digitizers.TipSwitch = 1
Digitizers.InRange = 1
GenericDesktop.X = 3687

[...]

report (size 6) (numbered)
report 2 (size 6) =  02 02 7b 0e dd 03
Digitizers.TipSwitch = 0
Digitizers.InRange = 1
GenericDesktop.X = 3707
GenericDesktop.Y = 989


