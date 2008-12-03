Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYLCMhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYLCMhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:37:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYLCMh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:37:29 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:21047 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117AbYLCMh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:37:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=vnOV+8fBRvliHHKX0nnBy8zDszO30y237qmI1rmHWgezo+dH6u15anNDTf4D9Vw6Rn
         vSrZ7vQehXzznnjttT+54RmGeNyo48Es9NcKfpzuKfPoFe3w8hQCJ+hslCGva08uDKtn
         rdbh3RrFP9hVuHbQhoo2wZMn/Lw4U6xqa8hsM=
Message-ID: <49367D82.8040305@tuffmail.co.uk>
Date: Wed, 03 Dec 2008 12:37:22 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Matt_Domsch@dell.com, greg@kroah.com, linux-acpi@vger.kernel.org,
       Richard Purdie <rpurdie@rpsys.net>, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2 update] misc: Add dell-laptop driver
References: <20081127163357.GA22846@srcf.ucam.org> <20081127163444.GB22846@srcf.ucam.org> <20081202115029.2b9d1153.akpm@linux-foundation.org> <20081202201645.GB31620@srcf.ucam.org>
In-Reply-To: <20081202201645.GB31620@srcf.ucam.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> misc: Add dell-laptop driver
>     
> Add a driver for controling Dell-specific backlight and rfkill interfaces.
> This driver makes use of the dcdbas interface to the Dell firmware to allow
> the backlight and rfkill interfaces on Dell systems to be driven through the
> standardised sysfs interfaces.
>     
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
>
> ---
>
> Contains Andrew's suggested updates, plus a fix for a leak on the init 
> error path.
>   

I see you don't call rfkill_set_default(). Do Dell firmwares support
persistent rfkill state?

My ill-informed guess is that it shouldn't hurt to call it. If the
firmware is sane, it will initialize the rfkill to a useful state.
Otherwise, the radio(s) would be unusable without the platform driver.
But do feel free to ignore me, if you suspect the firmware of insanity :).

Regards
Alan
