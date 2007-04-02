Return-Path: <linux-kernel-owner+w=401wt.eu-S965699AbXDBTGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965699AbXDBTGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 15:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965709AbXDBTGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 15:06:51 -0400
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:20754 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965699AbXDBTGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 15:06:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0rFjUYTibaT7wRVK/MycHok1XNE+zgq6cq3GCessykpfEaGuZNxm0wL+myBrPYQ58wvr00J/MmiBADDai2bDlcKrh5BufB4BpNwUw8PL+foTCpXIf/Yr7hCgh5qrUbBoHhjcmhsbh340L2JC5Psfvfr5PNcnHnS9X8F4iZBSZHQ=  ;
X-YMail-OSG: XmwDgacVM1lYnR.4WEdaxfJaURmfBgsylBN__Kdl4EYsbXOdsy.19756eS6mvvOJV.LSxkVHEA--
From: David Brownell <david-b@pacbell.net>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [patch 2.6.21-rc5-git 1/2] fix hotplug for legacy platform drivers
Date: Mon, 2 Apr 2007 09:59:28 -0700
User-Agent: KMail/1.7.1
Cc: Greg KH <gregkh@suse.de>, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andres Salomon <dilinger@debian.org>
References: <200703311455.38490.david-b@pacbell.net> <20070402124944.0ad74092@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070402124944.0ad74092@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020959.28875.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 3:49 am, Cornelia Huck wrote:
> On Sat, 31 Mar 2007 14:55:38 -0700,
> David Brownell <david-b@pacbell.net> wrote:
> 
> > This fix uses the newish per-device flag controlling issuance of "add" events.
> > (A previous version of this patch used a per-device "driver can hotplug" flag,
> > which only scrubbed $MODALIAS from the environment rather than suppressing the
> > entire hotplug event.)  It also shrinks that flag to one bit, saving a word in
> > "struct device".
> 
> Would this still work on top of
> driver-core-suppress-uevents-via-filter.patch (in -mm), which
> suppresses all uevents (not just the add event)? I'd think yes, but I'm
> not that familiar with platform devices :)

It depends what "yes" means.  ;)

Yes, as far as I can tell the only additional change (today) from
that "supress all events" patch would be that "remove" events would
also go away ... last time I checked, only add/remove events were
issued for those devices.

But long term, I wonder.  Isn't "no kevents issued" an extremely
blunt tool, which could cause lots of damage?  It might be better
to have selective filters, one per event family:  core (add/remove),
online/offline, mount/unmount, etc.

Specifically with respect to legacy drivers, it might make sense
that managing the devices they create not be confusable with managing
"real" devices, so I don't immediately suspect that suppressing ALL
the hotplug events might be troublesome.

But in general it's worth thinking about.  The comments on that
"suppress all kevents" patch didn't include any motivation at all.
Why do you want to prevent all kevents, rather than just a subset?

- Dave
