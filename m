Return-Path: <linux-kernel-owner+w=401wt.eu-S1030555AbXAYUkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030555AbXAYUkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 15:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030560AbXAYUkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 15:40:10 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:43923 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030555AbXAYUkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 15:40:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=U/Vtb1/PFY5LQ0fYe7aTEKW6s9FNuWUE+Ro+MdO/yATj+cwHA7D9vx/NCRrHnYLLQtBA8dJ0q2Sq8HN4xjG8Mz4BjcUD1G+8p0tf4246snyfPJkScuC67wqfVhUUArtlEjz9/U+DmRvA4TrmBQ6ZyOGEw8WZ5FHJlaDnYRlrFfk=
Message-ID: <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com>
Date: Thu, 25 Jan 2007 15:40:06 -0500
From: xiphmont@xiph.org
To: "Greg KH" <greg@kroah.com>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Takashi Iwai" <tiwai@suse.de>, "Pierre Ossman" <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <20070125194933.GA27857@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701250757n3dcb38b7ma5f8423ab3de9850@mail.gmail.com>
	 <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
	 <806dafc20701250930n185e9773i64bbd2d845c836be@mail.gmail.com>
	 <s5h7ivbuhg1.wl%tiwai@suse.de>
	 <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com>
	 <s5h4pqfufs8.wl%tiwai@suse.de>
	 <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com>
	 <s5h1wljuf2f.wl%tiwai@suse.de>
	 <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com>
	 <20070125194933.GA27857@kroah.com>
X-Google-Sender-Auth: dab2423b9685f6ea
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Basically, new distros can disable that option if their userspace can
> handle the new structure of sysfs with the symlinks.  Users of older
> distros with newer kernels can enable the option and (hopefully) not
> break anything.

I would like to register a general objection to a change of this size
'hoping to not break anything' in a stable release update (seeing as
how something did break), especially as how no one here who was
maintaining the userspace was apparently even aware it was coming.

> So far, it's been working with this being the first
> regression reported.

Had it worked properly, it still would have been a regression.  This
seems similar to the ALSA copout ("maintaining a kernel ABI is hard!
We require you have a userspace officially approved by us matching
your kernel, and that is your API.") except that in this case, the
userspace maintainence doesn't seem to be as tightly coupled (is hald
the only thing that broke?)

> > (Well, it's incomplete like my original patch was in that it only
> > changed the device symlinks for controlX and pcmX; the other entries
> > still had device entries pointing at card*).
>
> So what does running with this patch make sysfs look like?

A union of old and new, with old taking precedence over new when they
conflict.  That is, the [eg] pcmCXdXx entries look like old sysfs, but
the new entries for cardX etc are there too.  All device symlinks
point to /sys/device/pciXXXX:XX/XXXX:XX:XX.x entries as before.

Monty
