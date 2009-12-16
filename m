Return-Path: <linux-kernel-owner+w=401wt.eu-S933984AbZLPTvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984AbZLPTvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760286AbZLPTvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:51:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762486AbZLPTvm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:51:42 -0500
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
From: Dan Williams <dcbw@redhat.com>
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
Cc: Oliver Neukum <oliver@neukum.org>,
       Josua Dietze <digidietze@draisberghof.de>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
In-Reply-To: <20091216180337.GG16426@one-eyed-alien.net>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com>
	 <200912151611.08576.oliver@neukum.org>
	 <20091215180300.GF16426@one-eyed-alien.net>
	 <200912161129.27284.oliver@neukum.org>
	 <20091216180337.GG16426@one-eyed-alien.net>
Content-Type: text/plain
Date: Wed, 16 Dec 2009 11:50:48 -0800
Message-Id: <1260993048.2179.68.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 10:03 -0800, Matthew Dharm wrote:
> On Wed, Dec 16, 2009 at 11:29:27AM +0100, Oliver Neukum wrote:
> > Am Dienstag, 15. Dezember 2009 19:03:00 schrieb Matthew Dharm:
> > > > This would break existing systems and thus introduce a regression.
> > > > We'd need to go through a feature removal process. For the time being
> > > > I see no alternative to Seife's patch, as we cannot introduce ejection
> > > > code to another wireless driver and need to support these devices.
> > > 
> > > The right answer here is neither to move the eject code nor to introduce
> > > more of it.  New devices should be supported via userspace.
> > 
> > Usually I would agree, but in this case the vendor reused IDs.
> > The legacy kernel space switcher and user space would race.
> 
> So, let me see if I understand this... we have two devices that use the
> same IDs, and get mode-switched the same way, but need different
> post-switch drivers?
> 
> If this is the case, then the only reasonable answer to is to push the
> modeswitch code for both into udev and out of the kernel.  It will take

you mean usb_modeswitch, not udev actually.

> longer to support the new device that way (since we need to wait until udev
> is updated and then remove kernel support), but that's what a vendor gets
> for re-using IDs.
> 
> Matt
> 

