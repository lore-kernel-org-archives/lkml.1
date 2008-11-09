Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbYKIUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbYKIUrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755829AbYKIUrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:47:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44824 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806AbYKIUrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:47:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Date: Sun, 9 Nov 2008 21:51:57 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org
References: <20081109202830.GA7206@x61> <20081109203441.GA4871@kroah.com>
In-Reply-To: <20081109203441.GA4871@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811092151.57620.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of November 2008, Greg KH wrote:
> On Sun, Nov 09, 2008 at 09:28:30PM +0100, Tino Keitel wrote:
> > Hi,
> > 
> > my Mac mini Core Duo doesn't wake up from suspend to RAM anymore with
> > 2.6.27.4. It works with 2.6.27.3. I enabled pm_trace, but dmesg | grep
> > "hash matches" didn't show anything after resume. I tried 2.6.27.5,
> > which also failed to resume.
> > 
> > The system is i386, the hardware is basically Intel based: Core Duo
> > T2300 CPU, Intel graphics i945, ICH7, Marvell GbE (sky2), a SATA hard
> > disk, PATA DVD drive, a Firewire hard disk, and a lot of USB devices.
> > 
> > Does that ring any bells? Any hints what commit I should try to revert?
> 
> Can you run 'git bisect' on the patches in 2.6.27.4 to see which one
> broke your box?

I would start from these commits:

3b987ac961486373f91191b14291b331fa546072
"ACPI suspend: Always use the 32-bit waking vector"

66036f5862883fcc9f7ff8550685a5a3de1a57e4
"ACPI Suspend: Enable ACPI during resume if SCI_EN is not set"

If none of them causes this problem to happen, I have no idea what can, so
please bisect in this case.

If any of them breaks suspend for you, we'd have to find out why, because
both of them are rather important bug fixes.

Thanks,
Rafael
