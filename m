Return-Path: <linux-kernel-owner+w=401wt.eu-S934310AbZHENLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbZHENLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 09:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933803AbZHENLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 09:11:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52382 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933766AbZHENLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 09:11:19 -0400
Date: Wed, 5 Aug 2009 14:11:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <teheo@suse.de>
Cc: Takashi Iwai <tiwai@suse.de>, Colin Guthrie <cguthrie@mandriva.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805141157.6d6b857c@lxorguk.ukuu.org.uk>
In-Reply-To: <4A797C84.2050109@suse.de>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A794FB9.30403@mandriva.org>
	<20090805105916.28f84a05@lxorguk.ukuu.org.uk>
	<s5h63d2o9ds.wl%tiwai@suse.de>
	<20090805112649.4a59ce70@lxorguk.ukuu.org.uk>
	<s5hzlaemtdx.wl%tiwai@suse.de>
	<4A797C84.2050109@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we're gonna do that, we might as well just rip off the pointless
> 'claim everything so we can use our own module alises' code from
> sound_core.c and be done with it.  That really is the only problem.

The interface expected is the sound_register_* interface and the sharing
is likewise expected so you could for example mix OSS. CUSE and ALSA oss
emulation drivers on the same system at the same time.

Rewriting sound_register* in terms of minor number allocations using the
fact modern kernels have better allocators for devices would also be
preferable to the weird module hacks initially proposed. I guess a
starting point would be to tweak soundcore to generate both message sets
itself for a year and then pull the old stuff out.

Alan
