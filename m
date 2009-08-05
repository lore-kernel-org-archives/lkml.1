Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbZHEJdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbZHEJdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933960AbZHEJdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:33:11 -0400
Received: from brent.tribalogic.net ([78.86.109.144]:63046 "EHLO
	brent.tribalogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933925AbZHEJdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:33:08 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2009 05:33:08 EDT
Message-ID: <4A794FB9.30403@mandriva.org>
Date: Wed, 05 Aug 2009 10:24:09 +0100
From: Colin Guthrie <cguthrie@mandriva.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090731)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tejun Heo <teheo@suse.de>, Greg KH <greg@kroah.com>,
       Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de> <20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'Twas brillig, and Alan Cox at 05/08/09 10:15 did gyre and gimble:
> On Wed, 05 Aug 2009 15:40:42 +0900
> Tejun Heo <teheo@suse.de> wrote:
> 
>> If any OSS support is enabled, regardless of built-in or module,
>> sound_core claims full OSS major number (that is, the old 0-255
>> region) to trap open attempts and request sound module automatically.
>> This feature is redundant as chrdev already has such mechanism and no
>> longer used by modern distros.  This preemptive claiming prevents
>> alternative OSS implementation.
>>
>> This patch makes the preclaiming optional and adds a config option
>> SOUND_OSS_CORE_PRECLAIM and kernel parameter soundcore.preclaim_oss to
>> control whether preclaim is enabled or not.  This allows distros and
>> developers to try new things without rebuilding kernel.
> 
> This looks like a random private devel hack sand I don't see why it's
> appropriate for mainstream, especially as these "new things" don't exist
> mainstream either.

While I'm not familiar enough with the kernel itself to comment on *how* 
the patch works, the principle is quite important here.

As far as I know most distros enable snd-*-oss module loading via a 
modprobe trick (e.g. in user space) so the change here shouldn't affect 
this approach.

However, I certainly want to experiment with osspd and while I hope it's 
going to be a good solution generally, it'll only make sense if the user 
chooses to use pulseaudio.

If the user decided they want to use pure alsa, then they'll have to 
drop back to using snd-*-oss for that instead.

This is all something I'd like to enable without making the user change 
kernels based on a preference.

So if this patch is not accepted, I'd still like to see the kernel not 
claim this device number, and leave it up to userspace to load the modules.

Sorry if this is not all factually accurate, but I think i've got the 
gist right! :)

-- 

Colin Guthrie
cguthrie(at)mandriva.org
http://colin.guthr.ie/

Day Job:
   Tribalogic Limited [http://www.tribalogic.net/]
Open Source:
   Mandriva Linux Contributor [http://www.mandriva.com/]
   PulseAudio Hacker [http://www.pulseaudio.org/]
   Trac Hacker [http://trac.edgewall.org/]
