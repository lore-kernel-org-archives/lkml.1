Return-Path: <linux-kernel-owner+w=401wt.eu-S934573AbXGaVaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573AbXGaVaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934336AbXGaV3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:29:51 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:58637 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934478AbXGaV3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:29:49 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns; b=M6mTpaCir3cHbKVSJfFk+Crsyj2elJxdd0MFwRimnGXizaLo4gZyeAhEa+yOJhwLnMnFimoTRikof8w0kY53SHgaemsEO77nl3CrUmMG06PQtuCCgb/3uAh1FKJJNell;
X-IronPort-AV: E=Sophos;i="4.19,205,1183352400"; 
   d="scan'208";a="325903775"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: USB-related instability on 2.6.23-rc1
Date: Tue, 31 Jul 2007 16:29:48 -0500
Message-ID: <DFEF91B22ED07447AB6AA4B237F913F9B18D8C@ausx3mpc125.aus.amer.dell.com>
In-Reply-To: <20070731212454.GB18839@kroah.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: USB-related instability on 2.6.23-rc1
Thread-Index: AcfTuV0DSvMm+9L3SNuGfYAbW0qPggAAB5nw
References: <fa686aa40707311406w10169a20ibbef77c198020af8@mail.gmail.com> <20070731212454.GB18839@kroah.com>
From: <Stuart_Hayes@Dell.com>
To: <greg@kroah.com>, <grant.likely@secretlab.ca>,
       <linux-usb-devel@lists.sourceforge.net>
Cc: <linux-kernel@vger.kernel.org>, <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 31 Jul 2007 21:29:48.0669 (UTC) FILETIME=[EC1702D0:01C7D3B9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Jul 31, 2007 at 03:06:07PM -0600, Grant Likely wrote:
>> I've observed instability on my Macbook c2d with the Linus' latest
>> tree.  Symptom is that USB devices start behaving badly and the
>> kernel seems to be registering incorrect HID events; (ie. moving the
>> mouse causes odd keyboard events).  If I continue to attempt to use
>> the 
>> mouse, it results in a system freeze (and I don't see any kind of
>> backtrace in /var/log/kern.log).  To reproduce the problem, I just
>> need to be using the keyboard/mouse.  If I leave the system idle, the
>> problem does not seem to occur.  If I actively use the
>> keyboard/mouse, the problem can occur at any time; usually within
>> 5-10 minutes. 
>> 
>> In my particular case, I've got both a USB key/mouse pair on the
>> laptop and an external key/mouse pair plugged in via a hub.
>> Typically, it's the external mouse that exhibits badness first.
>> 
>> USB HID devices are definitely affected.  I have not tested USB block
>> devices.  Isochronous transfers to a USB headset appear to be
>> unaffected, but that's under minimal testing.
>> 
>> I've bisected down to commit
>> 196705c9bbc03540429b0f7cf9ee35c2f928a534, "USB: EHCI cpufreq fix" 
>> 
>> Reverting the patch at the head of the tree makes the kernel stable
>> again. 
>> 
>> I've attached my kernel config file and a dmesg output
> 
> Can you enable CONFIG_USB_DEBUG and send the linux-usb-devel list and
> us, the output when you have these problems? 
> 
> thanks,
> 
> greg k-h

I'm actually in the process right now of attaching a patch for this
problem (well, I hope it's a patch for the problem you're seeing) right
now on the bugzilla (bug 8535 at bugzilla.kernel.org).  If you'd like to
test it, that would be great.

Thanks,
Stuart
