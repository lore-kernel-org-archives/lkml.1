Return-Path: <linux-kernel-owner+w=401wt.eu-S1759041AbZBYVRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbZBYVRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbZBYVRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:17:23 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:46659 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbZBYVRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:17:23 -0500
Date: Wed, 25 Feb 2009 23:17:17 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: david.hagood@gmail.com
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Odd behavior in musb_hdrc OTG if gadget drivers are modules
Message-ID: <20090225211716.GD4639@gandalf>
Reply-To: me@felipebalbi.com
References: <6cc6e376b34fd371cf946c1660c97f6e.squirrel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cc6e376b34fd371cf946c1660c97f6e.squirrel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 03:46:28PM -0600, david.hagood@gmail.com wrote:
> I've spend the day tracking down a weird behavior on a Beagleboard with
> 2.6.29-rc2-omap1.
> 
> If you select the mode for the musb to operate in OnTheGo mode
> (CONFIG_USB_MUSB_OTG), and if you compile the gadget drivers as modules,
> the the USB port will NOT be brought up at system boot, even if it has a
> USB mini-A cable plugged in (and thus should be in host mode, not gadget
> mode).
> 
> If you then modprobe an appropriate gadget driver, then the interface will
> be brought up in host mode.

that's expected. When you have otg selected, you can only let musb work
when it's fully functional on both roles ;-)

> If you DON'T modprobe a gadget driver, AND you attempt to force the port
> to host mode by
>   echo host > /sys/devices/platform/musb_hdrc/mode
> 
> Then we get a kernel page fault trying to change modes, even though we are
> changing to host mode, which should be valid.
> 
> It seems to me that either the port should be brought up in host mode if
> no gadget drivers are loaded, and an attempt to switch to gadget mode
> should fail if no driver is loaded, OR there should be a config options to
> set what the default gadget driver is in the absence of one being loaded
> by the system.

not really, imagine what would happen, for example, if when you don't
have a gadget driver loaded, the other side tries HNP...

-- 
balbi
