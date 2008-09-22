Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYIVVEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYIVVEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 17:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYIVVEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 17:04:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35520 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbYIVVEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 17:04:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: Wakeup from suspend via keyboard and mouse doesn't work anymore with 2.6.27-rc
Date: Mon, 22 Sep 2008 23:09:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20080922202911.GA9832@dose.home.local>
In-Reply-To: <20080922202911.GA9832@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809222309.34413.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 22 of September 2008, Tino Keitel wrote:
> Hi,

Hi,

> my Mac mini core duo used to wake up from suspend to RAM when a key or
> mouse button is pressed. This doesn't work anymore with 2.6.27-rc, the
> current version that I tried is 2.6.27-rc7. I checked /proc/acpi/wakeup
> for differences, with 2.6.26 and 2.6.27-rc, but both were identical:

Did you test that with any 2.6.27-rc before -rc7?

> Device	S-state	  Status   Sysfs node
> PXS1	  S4	 disabled  pci:0000:01:00.0
> PXS2	  S4	 disabled  pci:0000:02:00.0
> USB1	  S3	 disabled  pci:0000:00:1d.0
> USB2	  S3	 disabled  pci:0000:00:1d.1
> USB3	  S3	 disabled  pci:0000:00:1d.2
> USB4	  S3	 disabled  pci:0000:00:1d.3
> USB7	  S3	 enabled   pci:0000:00:1d.7
> 
> Wakeup with the power switch at the back still works.
> 
> Any hints if there are some commits that I should try to revert, before
> I start bisecting?

I don't think you need to revert anything. :-)

Please check if the /sys/devices/.../power/wakeup file contains 'enabled' for
the USB controller pci:0000:00:1d.7 (I assume this is the one the keyboard &
mouse are attached to).  If it doesn't, please try to write 'enabled' to this
file and retest.

Thanks,
Rafael
