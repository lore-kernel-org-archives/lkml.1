Return-Path: <linux-kernel-owner+w=401wt.eu-S934499AbZHEOQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499AbZHEOQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 10:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934379AbZHEOQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 10:16:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:39776 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933615AbZHEOQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 10:16:28 -0400
Message-ID: <4A799436.9020409@suse.de>
Date: Wed, 05 Aug 2009 23:16:22 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, Colin Guthrie <cguthrie@mandriva.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de>	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>	<4A794FB9.30403@mandriva.org>	<20090805105916.28f84a05@lxorguk.ukuu.org.uk>	<s5h63d2o9ds.wl%tiwai@suse.de>	<20090805112649.4a59ce70@lxorguk.ukuu.org.uk>	<s5hzlaemtdx.wl%tiwai@suse.de>	<4A797C84.2050109@suse.de> <20090805141157.6d6b857c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805141157.6d6b857c@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Alan Cox wrote:
>> If we're gonna do that, we might as well just rip off the pointless
>> 'claim everything so we can use our own module alises' code from
>> sound_core.c and be done with it.  That really is the only problem.
> 
> The interface expected is the sound_register_* interface and the sharing
> is likewise expected so you could for example mix OSS. CUSE and ALSA oss
> emulation drivers on the same system at the same time.

If OSS behaves like a good chrdev and claims what it can really do,
all that can be done so much easier at the chrdev level.

> Rewriting sound_register* in terms of minor number allocations using the
> fact modern kernels have better allocators for devices would also be
> preferable to the weird module hacks initially proposed. I guess a
> starting point would be to tweak soundcore to generate both message sets
> itself for a year and then pull the old stuff out.

I don't disagree with you in that the above would be the perfect
technical solution but I just don't think the balance sheet is right.

Thanks.

-- 
tejun
