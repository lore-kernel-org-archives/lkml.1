Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbZCEGcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbZCEGcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 01:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZCEGcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 01:32:10 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:55584 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbZCEGcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 01:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ugwn/lPMMIkOdPwPvKLsIKaoJ/bizuEzSPDayDp8C0Rg2wzOwQzG7fo8w9YF+Frvtz
         +ROovxS3cstEBgXa+sgr8iv/KWOBoKYIKA9sy11K0VtqCcvHIKzcjKMN8MkaeJ7b28HN
         asUJWWoxlA3pKufsfLifwt/9qTW/WAuTNa8Fk=
Date: Wed, 4 Mar 2009 22:32:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arjan Opmeer <arjan@opmeer.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How to handle Elantech touchpad that occasionally sends bogus
	coordinates?
Message-ID: <20090305063201.GB14884@dtor-d630.eng.vmware.com>
References: <20090304215556.GA16612@adopmeer.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304215556.GA16612@adopmeer.homeip.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

On Wed, Mar 04, 2009 at 10:55:56PM +0100, Arjan Opmeer wrote:
> 
> Recently a user complained that when using the Elantech driver the mouse
> pointer would occasionally jump some distance away, or that when scrolling
> the scrolled page would suddenly jump back a bit.
> 
> It turns out that when starting a new touch action on this particular model
> the touchpad does not reliably emit the new coordinates but can repeat one
> or two of the coordinates of the last release point. This misreporting can
> last several motion packets depending on the number of fingers that are
> touching.
> 
> We came up with a workaround that basically discards mouse packets as long
> as the number of fingers is increasing. Like so:
> 
> 
>    if (fingers > old_fingers) {
>        discard packet
>    }
> 
> With this fix in place the user no longer suffers from the jumpy mouse
> cursor or the jumpy scrolling. He reports no impact on the responsiveness of
> the touchpad.
> 
> My question now is whether this is the right approach to fix this issue? Is
> such a workaround acceptable and should it live in the kernel? Can or should
> this problem be better solved in the Xorg Synaptics driver?
> 

This is purely hardware problem and I believe it should be fixed in the
kernel; userspace should not be aware that device may emit wrong
coordinates.

Thanks!

-- 
Dmitry
