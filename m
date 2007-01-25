Return-Path: <linux-kernel-owner+w=401wt.eu-S965565AbXAYSeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965565AbXAYSeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 13:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965566AbXAYSeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 13:34:21 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:37460 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565AbXAYSeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 13:34:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KreI59dV4TZqrxwWSqSh7r/1cN6PKD/eHzIMXfaWMU6nVNX6MFHKCZFER6+2bDcw1Kc6H0jkhqacpyKuxd+3GktxndIcpRlN+Daz4M2A7dm9kbOQdMTFvaKw0iUXB9T/bGS7n5JhS0JfnIVs8kk4uCy7zUFTNzpsK+/wmj+Krg0=
Message-ID: <806dafc20701251034l59fc5be7ta881606046eb819a@mail.gmail.com>
Date: Thu, 25 Jan 2007 13:34:19 -0500
From: xiphmont@xiph.org
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Pierre Ossman" <drzeus@drzeus.cx>, fedora-desktop-list@redhat.com,
       alsa-devel@alsa-project.org, jrb@redhat.com, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <s5h4pqfufs8.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
	 <806dafc20701250736yc5c3048u14ec98e9b6b92574@mail.gmail.com>
	 <45B8CF7E.2040908@drzeus.cx>
	 <806dafc20701250757n3dcb38b7ma5f8423ab3de9850@mail.gmail.com>
	 <s5hfy9zujvr.wl%tiwai@suse.de>
	 <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
	 <806dafc20701250930n185e9773i64bbd2d845c836be@mail.gmail.com>
	 <s5h7ivbuhg1.wl%tiwai@suse.de>
	 <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com>
	 <s5h4pqfufs8.wl%tiwai@suse.de>
X-Google-Sender-Auth: e6f2bd25660a5046
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Takashi Iwai <tiwai@suse.de> wrote:

> The problem with your patch is that it breaks the structure newly
> introduced.  In the new tree, card* contains the whole belonging
> devices, and each device points to the one in the card object.
> Passing dev->parent there cuts the relation between the card object
> and each device.
>
> That's why my patch rules out setting card->dev with ifdef
> CONFIG_SYSFS_DEPRECATED.  As fallback, it takes the parent device to
> build the old style tree.
>
> > Having just checked a 2.6.18 machine, none of the device symlinks
> > point to card* objects; thay all point to /sys/devices/....
>
> Yes, it's a new stuff.

[This does beg the question: Does the benefit of this complete
restructuring in a subminor release of an allegedly stable kernel
outweigh the fact that it breaks all audio for any user running a
gnome desktop?]

OK, so my patch should be passing card->parent or dev->parent only in
the case that CONFIG_SYSFS_DEPRECATED is set, and leaving the call the
way it was previously in the case CONFIG_SYSFS_DEPRECATED is not set.
Essentially, ifdef/else both cases?

Is this also going to have to be the case for every other class type
that converts from class_device_create to device_create?

Monty




>
>
> Takashi
>
