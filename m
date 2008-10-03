Return-Path: <linux-kernel-owner+w=401wt.eu-S1754486AbYJCTm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbYJCTm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYJCTmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:42:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46253 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752834AbYJCTmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:42:21 -0400
Date: Fri, 3 Oct 2008 21:37:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Jeffrey W. Baker" <jwbaker@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Put unused PCI devices in D3
Message-ID: <20081003193718.GB1497@ucw.cz>
References: <1222719064.19236.129.camel@squeak.gghcwest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222719064.19236.129.camel@squeak.gghcwest.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> My laptop computer has half a dozen unused PCI devices that could be put
> in the D3 power state, but they loiter in D0.  The audio codec, the
> ethernet adapter, the unused PCI Express port, all the USB controllers,
> the IEEE1394 controller, the SD/MMC card controller, and the cardbus
> bridge all support D3(hot) power state.
> 
> Currently it looks to me from browsing the code that D3 is only used in
> Linux when the whole machine is headed for S3, and the drivers are asked
> to suspend.  I think the drivers should be able to enter D3 in other
> circumstances:
> 
> * During pci_unregister_driver ... i.e. on module unload
> * When a network interface is downed
> * If the device is a bridge or hub with no downstream device
> * Whenever userspace requests D3 via sysfs

Well, patch that would put all unused devices into D3 would be
certainly 'interesting'. Then we  could measure power savings and
perhaps do it... (or not if it breaks machines as Mathew suggests).

> So, what fundamental problem prevents me from, for example, calling
> pci_set_power_state() from ohci1394's __exit?

Patch would be welcome.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
