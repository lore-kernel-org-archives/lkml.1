Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYABTco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYABTco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYABTch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:32:37 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:59404 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbYABTcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:32:35 -0500
X-Greylist: delayed 2151 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2008 14:32:35 EST
Date: Wed, 2 Jan 2008 13:57:50 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-usb-devel@lists.sourceforge.net,
       Robin Getz <rgetz@blackfin.uclinux.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB
	options normally reserved for OTG
Message-ID: <20080102185745.GA17890@kedavra.cpe.vivax.com.br>
Reply-To: me@felipebalbi.com
References: <200801020948.51310.rgetz@blackfin.uclinux.org> <200801021047.16036.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801021047.16036.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [0 0]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 10:47:15AM -0800, David Brownell wrote:
> On Wednesday 02 January 2008, Robin Getz wrote:
> > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > 
> > Allow embedded developers to turn support for USB Hubs off even if they have a 
> > full root hub. This saves the overhead (RAM and Flash size).
> 
> ISTR that it won't save very much code though ... the Linux USB
> stack structures all its enumeration logic around hubs.
> 
> 
> > Allow embedded developers the capabilities of the "otg_whitelist.h" - a 
> > product whitelist, so USB peripherals not listed there will be rejected 
> > during enumeration. This is the desired operation for many embedded products.
> > 
> > Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
> 
> This is probably the right thing to do.  Correct me if I'm wrong,
> but USB-IF recently put out some specs about "embedded hosts" which
> basically boil down to saying you can adopt the same functionality
> restrictions that used to be OTG-only.  Which is why now there are
> embedded developers who'd like this option.  :)

otg whitelist is not a blocker. A device that is not listed on TPL
might or might not work. The logic around that should be something like:

parse_whitelist()
if (!listed) {
	match_class_with_tpled_devices();
		if (match_any)
			check_power_need();
			if (power_need <= 100mA)
				allow_enumeration();
			else
				deny_enumaration_and_message();

If you check n810, you'll see that even though a usb memory stick is not
listed on its TPL, we allow it to enumerate as long as it draws less
then 100mA and this is true on something around 95% of usb memory
sticks.

I'm kinda busy with other tasks right now, but when I finish formating
proper patches for current mainline head, I'll release some code adding
support for dynamic otg tpl. The problem I see here is that my only
"user" is musb driver, currently only available on linux-omap git tree.

Maybe it's time to send it to mainline, what do you think Dave?

In any case, I'll format such patches when I'm done with twl4030 and
isp1301 development, something around 3 ~ 4 weeks from now.

Even though, embedded hosts should have the same behavior.

Best Regards,

Felipe Balbi
