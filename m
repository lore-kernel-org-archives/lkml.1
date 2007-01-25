Return-Path: <linux-kernel-owner+w=401wt.eu-S1030462AbXAYRaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030462AbXAYRaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030471AbXAYRaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:30:46 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:11812 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030462AbXAYRap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:30:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=stf+AHU/k5+iNnggsNP3onb4N1P4ZKkV8aLpbHP0+giTWqSVNzKCzEMQaKcW/cOmhixWsEbS2xR41G2QpHQ0L7BqnyjAM+jfyezI15ejhjLkv5+9wR4EniXKl/Q0WMGa/08V5OjrKfDs8jO9/DNNylj4Dyn6eL1d9G20HNr/pD4=
Message-ID: <806dafc20701250930n185e9773i64bbd2d845c836be@mail.gmail.com>
Date: Thu, 25 Jan 2007 12:30:44 -0500
From: xiphmont@xiph.org
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Pierre Ossman" <drzeus@drzeus.cx>, fedora-desktop-list@redhat.com,
       alsa-devel@alsa-project.org, jrb@redhat.com, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
	 <20070125042616.GA21813@kroah.com>
	 <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>
	 <45B8C9A3.6060107@drzeus.cx>
	 <806dafc20701250736yc5c3048u14ec98e9b6b92574@mail.gmail.com>
	 <45B8CF7E.2040908@drzeus.cx>
	 <806dafc20701250757n3dcb38b7ma5f8423ab3de9850@mail.gmail.com>
	 <s5hfy9zujvr.wl%tiwai@suse.de>
	 <806dafc20701250903p6b67d176wf00dd2a9d92d899f@mail.gmail.com>
X-Google-Sender-Auth: d0e7be2ca04dec9e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm working on this now and will doublecheck just in case my test was
> flawed first time.

Doublechecking indicates my initial test was wrong somehow; both
card->dev->parent and card->parent passed as arg 2 to the
device_create call in snd_register_device result in correct device
symlinks. Are these two actually semantically different?  I'm just
curious.

The call to device_create in cound_core.c:sound_insert_unit also needs
to be modified in order for the device symlinks in the other unit
types to be correct.  Again, modifying the 'dev' argument to
'(dev?dev->parent:NULL)' appears to fix the problem.  Is that
correct/appropriate there?

Monty
