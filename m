Return-Path: <linux-kernel-owner+w=401wt.eu-S934122AbZHEJ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122AbZHEJ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934116AbZHEJ6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:58:39 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36590 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933319AbZHEJ6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:58:37 -0400
Date: Wed, 5 Aug 2009 10:59:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Colin Guthrie <cguthrie@mandriva.org>
Cc: Tejun Heo <teheo@suse.de>, Greg KH <greg@kroah.com>,
       Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805105916.28f84a05@lxorguk.ukuu.org.uk>
In-Reply-To: <4A794FB9.30403@mandriva.org>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A794FB9.30403@mandriva.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> While I'm not familiar enough with the kernel itself to comment on *how* 
> the patch works, the principle is quite important here.
> 
> As far as I know most distros enable snd-*-oss module loading via a 
> modprobe trick (e.g. in user space) so the change here shouldn't affect 
> this approach.
> 
> However, I certainly want to experiment with osspd and while I hope it's 
> going to be a good solution generally, it'll only make sense if the user 
> chooses to use pulseaudio.
> 
> If the user decided they want to use pure alsa, then they'll have to 
> drop back to using snd-*-oss for that instead.
> 
> This is all something I'd like to enable without making the user change 
> kernels based on a preference.

As you said "I'd like to experiment"

We don't put everyones random experiments in the kernel or we'd have a
kernel that had a million unfinished project hacks.

Suppose this doesn't work out - how do we get rid of the new hack,
someone might by then have decided to depend upon it. More crud, more
APIs we can't get rid of

More importantly there is an API *in* soundcore for registering sound
devices in the OSS category. You can use that.

Not only was that interface written precisely to allow the kind of
sharing in question but it will also let you mix OSS, ALSA *and* your own
experimental device work at the same time because it hands out minor
numbers properly.

Given we have an existing proper interface for this I think this hack
belongs in a private dev tree only. In fact I suspect it belongs in the
bitbucket and experimental code should be using the proper provided and
exported interfaces as it will need to if it is ever going to be accepted
upstream.

NAK

Alan
