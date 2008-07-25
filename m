Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYGYSo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYGYSo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYGYSos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:44:48 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:11572 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYGYSor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:44:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mMqmMScdk08mlfqkWlQcKYsRdyBbZ1oT0DWY0xTSLNNYYl36QOSHdO97sNKrli2Fzu
         jFJGxfiC3QkTPMagwwbv8WHiH1pvnq5rvzAaurA4bMww7YARI5d1BRmz9Q3uOzzEc8sj
         OikLQ0zzXOkawg2chINbitoRcXBam30aT74g4=
Date: Fri, 25 Jul 2008 14:37:56 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       robfitz@273k.net, akpm@osdl.org, jikos@jikos.cz, vojtech@suse.cz,
       dmonakhov@openvz.org, johannes@sipsolutions.net
Subject: Re: [PATCH] bcm5974-0.58: name changes, open/close and
	suspend/resume serialized
Message-ID: <20080725143015.ZZRA012@mailhub.coreip.homeip.net>
References: <4888311E.9010005@euromail.se> <20080725154250.GA1861@anvil.corenet.prv> <488A1A99.2070609@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488A1A99.2070609@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 08:25:29PM +0200, Henrik Rydberg wrote:
> Hello Dmitry,
> > 
> > Thank you for the changes.  You don't have to track whether device is
> > manually suspended or not - usb_submit_urb will fail and that is it.
> > 
> 
> Perfect.
> 
> > Attached are 2 patches. First cleans suspend state tracking as it is not
> > really needed and does some formatting and other minor changes and 2nd
> > implements runtime pm for the device. Could you please try them and if
> > everything still works I will apply the driver.
> 
> Patch 1:
> 
>   Looking good, just a few comments:
> 
>   * I notice that clamp_val is new since 2.6.24.3

Probably, I am not sure...

>   * Regarding the open-fails comment: is EACCES correct?

We don't return EACCESS anymore, I don't think. We will return what
bcm5974_start_traffic returns which in turn returns result of
usb_submit_urb and the likes.

I don't think returning -EACCESS was proper - it usually indicates
permisison issues, not the fact that the hardware is unavailable.

> 
> Patch 2:
> 
>   Perfect.
> 
> Thank you so much, Dmitry - it's a GO!
> 

Great, thank you!

-- 
Dmitry
