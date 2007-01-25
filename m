Return-Path: <linux-kernel-owner+w=401wt.eu-S965546AbXAYSHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965546AbXAYSHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 13:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965535AbXAYSHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 13:07:08 -0500
Received: from qb-out-0506.google.com ([72.14.204.237]:51187 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965516AbXAYSHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 13:07:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ciOzZiMGwatZV7A2zFMBc3aueKF+fkEItszRaHGMfx5W9Vy1UUjfmgCOD8/xsyav2G7EPm8Y8GJDMjYMI0zMNgqDYWeHCyzzvyPOmEpcFngEmrx4Y5T5fWIPLFeM/qyRKhrRPcJznTavvGquk9rm8viFrFWxxndOxKSYY1wsw8s=
Message-ID: <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com>
Date: Thu, 25 Jan 2007 13:07:04 -0500
From: xiphmont@xiph.org
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Pierre Ossman" <drzeus@drzeus.cx>, fedora-desktop-list@redhat.com,
       alsa-devel@alsa-project.org, jrb@redhat.com, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <s5h7ivbuhg1.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
	 <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>
	 <45B8C9A3.6060107@drzeus.cx>
	 <806dafc20701250736yc5c3048u14ec98e9b6b92574@mail.gmail.com>
	 <45B8CF7E.2040908@drzeus.cx>
	 <806dafc20701250757n3dcb38b7ma5f8423ab3de9850@mail.gmail.com>
	 <s5hfy9zujvr.wl%tiwai@suse.de>
	 <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
	 <806dafc20701250930n185e9773i64bbd2d845c836be@mail.gmail.com>
	 <s5h7ivbuhg1.wl%tiwai@suse.de>
X-Google-Sender-Auth: 7da94f51c8b5bbbe
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 25 Jan 2007 12:30:44 -0500,
> xiphmont@xiph.org wrote:
> >
> > > I'm working on this now and will doublecheck just in case my test was
> > > flawed first time.
> >
> > Doublechecking indicates my initial test was wrong somehow; both
> > card->dev->parent and card->parent passed as arg 2 to the
> > device_create call in snd_register_device result in correct device
> > symlinks. Are these two actually semantically different?  I'm just
> > curious.
>
> If card->dev is created, they should be identical.
> But, again, card->dev should be NULL on the older systems.
>
> > The call to device_create in cound_core.c:sound_insert_unit also needs
> > to be modified in order for the device symlinks in the other unit
> > types to be correct.  Again, modifying the 'dev' argument to
> > '(dev?dev->parent:NULL)' appears to fix the problem.  Is that
> > correct/appropriate there?
>
> Your change breaks the expected heavior if CONFIG_SYSFS_DEPRECATED is
> enabled.  Then devices won't belong to card* objects any more...

FWIW, CONFIG_SYSFS_DEPRECATED is enabled on all my machines-- it's
exactly that behavior that is wrong in 2.6.20-rc5 and that I'm trying
to fix (and testing against here/now).

Having just checked a 2.6.18 machine, none of the device symlinks
point to card* objects; thay all point to /sys/devices/....

Monty
