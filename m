Return-Path: <linux-kernel-owner+w=401wt.eu-S1764203AbYFFGKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764203AbYFFGKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 02:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYFFGKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 02:10:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:28356 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYFFGKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 02:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YJq3wLn7fWqXA3GcVoZG0YcKN79EFpsijMsvRG0V87Ze6EWk4qKgY/rslnA3LKq4Xa
         rCOuVoXAlfj+FUMiTUoPRLGnajlwTGFLjmwMT2GrwxyfMPlvG2KUkPCWKaoLlcoh7UBw
         E43rrC3tprVeEgc8XElwbUDoZsDjbWvHnJs8o=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Fri, 6 Jun 2008 06:07:29 +0000
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200806010415.05290.chris2553@googlemail.com> <20080605221709.f248eb90.akpm@linux-foundation.org>
In-Reply-To: <20080605221709.f248eb90.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806060607.29460.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 June 2008, Andrew Morton wrote:
> On Sun, 1 Jun 2008 04:15:05 +0000 Chris Clayton <chris2553@googlemail.com> 
wrote:
> > Hi,
> >
> > I've just started testing 2.6.26 on my desktop machine and have found
> > that I get a long pause (20 seconds or so) as the system boots. By pause
> > I mean that the boot messages that normally scroll by stop doing so for,
> > as I say, about 20 seconds.
> >
> > I've done a bisect and arrived at:
> >
> > b0ed43360fdca227048d88a08290365cb681c1a8 is first bad commit
> > commit b0ed43360fdca227048d88a08290365cb681c1a8
> > Author: Hannes Reinecke <hare@suse.de>
> > Date:   Tue Mar 18 14:32:28 2008 +0100
> >
> >     [SCSI] add scsi_host and scsi_target to scsi_bus
> >
> >     This patch implements scsi_host and scsi_target device types
> >     and adds both to the scsi_bus.
> >
> >     Signed-off-by: Hannes Reinecke <hare@suse.de>
> >     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> >     Signed-off-by: James Bottomley
> > <James.Bottomley@HansenPartnership.com>
> >
> > :040000 040000 4e3140909966b4c9aa987d34ee4078d283fe0351
> >
> > 46e4fd28cc537ba700eb4f5652abf043fed4d76d M      drivers
> >
> > The config file for that kernel is attached as are the kernel log for
> > booting that kernel and the bisect log.
> >
> > I've also noticed that it takes much longer for icons to appear on my
> > desktop when I plug a usb storage device in. (The icons are shown/hidden
> > by a simple sctript that is run via udev when the device is
> > attached/detached.)
>
> Do you believe that this is the same period?  20 seconds?
>

Thanks for the reply, Andrew. I was beginning to think that I'd committed an 
LKML sin :-)

Yes, it is about the same. On 2.6.25.4 (and earlier), the icons appear within a 
second or two, but with 2.6.26-rc2 or later, it takes about 20 seconds. I've 
now built and installed -rc5 and am seeing the same behaviour.

I've also built -rc5 on my laptop. On that my kernel uses the older IDE drivers 
rather than libata. The boot proceeds with no pause, but I do see the same 
delay in the desktop icons appearing when I attach a usb-storage device.

> > Let me know of any way I can help solve this.
> >
> > Please cc me to any reply as I'm not subscribed.
>
> cc's added.
>
> Rafael, we might need to track this as a post-2.6.26 regression.



-- 
Beauty is in the eye of the beerholder.
