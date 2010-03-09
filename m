Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab0CISlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:41:39 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:38665 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab0CISlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:41:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kMoc/OcL8N3qT6YJ7Lx7I6iTfBazKVsZLSbAOn0mO/560G/AnzbqlPnLtLA0Th88L8
         pBMtdASh9ytZ3c+XvcDNvi9xZtUXmchgJ5SYZpohgh8jq/eWDHjweLQDZD6B7P+TRMmo
         PZbIInRSKkJxVCAJIs8riSq6W3z1MK5QQJWxM=
Date: Tue, 9 Mar 2010 10:41:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: linux-input@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dima Zavin <dmitriyz@google.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Jean Delvare <khali@linux-fr.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-iio@vger.kernel.org
Subject: Re: [BUG?] hid-core.c: hid->name = dev->manufacturer + dev->product
 ... why not + dev->serial?
Message-ID: <20100309184127.GE19814@core.coreip.homeip.net>
References: <201003071655.06644@rk-nord.at>
 <20100309082216.GG17288@core.coreip.homeip.net>
 <201003091342.20273@rk-nord.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003091342.20273@rk-nord.at>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 01:42:20PM +0100, Melchior FRANZ wrote:
> 
> > Nevertheless serials are exported in sysfs ('uniq' attribute). Also udev
> > can give persistent names device nodes based on physocal connection,
> > serial numbers, etc.
> 
> It's not much fun to use all sorts of additional Linux specific interfaces,
> because the responsible one doesn't do its job.
> 

Have you considered the fact that maybe you not using the
right interface? The legacy joystick interface (with all its warts like
"replaying" the button state, in-kernel scaling and defuzzing, etc.) is
not what I would think a good general-purpose data acquisition
interface.

FWIW evdev does provide access to serial numbers (EVIOCGUNIQ) but even
that in my opinion is not the proper interface, for the reasons I
mentioned in my previous email.

You need to work with guys at linux-iio@vger.kernel.org (which stands
for Industrial I/O which is exactly what you are working with).

-- 
Dmitry
