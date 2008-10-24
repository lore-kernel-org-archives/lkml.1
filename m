Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYJXUUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYJXUUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbYJXUUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:20:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:58923 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbYJXUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:20:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=teJDyVIP5yOcqXG9ZiePIA/2LwI34SSvnGZ2UT58oOEwJfxg4tPXpQWcNZaO9O5X8Q
         j30sgWA8d6qluJTHWUrepuuOXHDGHdVqOgsoEJEw3eEAkfu/Cd86JQ8aiNDqYvqBr7rU
         cOnpmSgQRVwxnzM5TRtfRDT4/QBQxiukvLTvQ=
Message-ID: <d9def9db0810241320w3d4cc0b2qae3e4f09b863a12f@mail.gmail.com>
Date: Fri, 24 Oct 2008 22:20:06 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>
In-Reply-To: <d9def9db0810241315qde568c8yeff2af3511d24bb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221359h5118b8d2pd6d2b3f4f95496ce@mail.gmail.com>
	 <20081024153509.0f51d676@pedra.chehab.org>
	 <d9def9db0810241315qde568c8yeff2af3511d24bb7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 10:15 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> On Fri, Oct 24, 2008 at 7:35 PM, Mauro Carvalho Chehab
> <mchehab@infradead.org> wrote:
>> On Wed, 22 Oct 2008 22:59:00 +0200
>> "Markus Rechberger" <mrechberger@gmail.com> wrote:
>>
>>>     em2880-dvb:
>>>     * supporting the digital part of Empia based devices, which
>>> includes ATSC, ISDB-T and DVB-T
>>>
>>>     em28xx-aad.c:
>>>     * alternative audio driver, can be used instead of em28xx-audio if
>>> alsa is not available
>>>     or not compiled into the kernel, it provides a raw interface to
>>> the PCM samples
>>>
>>>     em28xx-audio.c:
>>>     * em28xx alsa driver and audio driver for FM radio
>>>
>>>     em28xx-audioep.c:
>>>     * em28xx alsa driver for devices which are set to vendor specific
>>> audio on interface 1,
>>>     in that case snd-usb-audio will not attach to the interface and
>>> em28xx-audioep will be needed
>>>
>>>     em28xx-cards.c:
>>>     * card definition and initial setup of devices.
>>>
>>>     em28xx-core.c:
>>>     * core videohandling and VBI frame slicing
>>>
>>>     em28xx-i2c.c:
>>>     * i2c setup and GPIO setup handling of the devices (including
>>> em2888 based ones)
>>>
>>>     em28xx-input.c:
>>>     * currently mostly disabled since the linuxtv input handling is
>>> broken by design and racy
>>>
>>>     em28xx-keymaps.c:
>>>     * keymap references of some remotes (could be merged into
>>> ir-common, although as mentioned
>>>     this should be in userland done by lirc).
>>>
>>>     em28xx-video.c:
>>>     * inode handling for analog TV, radio and VBI, also some device probing
>>>
>>>     em28xx-webcam.c:
>>>     * videology webcam specific i2c commands
>>
>> NACK.
>>
>> There's already a driver for em28xx. Be welcome sending incremental patches to
>> improve, like other developers do. But another driver for the same chip would
>> just create a mess.
>>
>
> the description right above shows up what the current driver is
> missing, excluding the bugfixes.
> Technical reasons why the source is basically kept in the structure as
> it is, is eg. higher backward
> compatibility without having to update the whole system. See eeePC
> packages which are available
> from some vendors. The driver seamlessly works with the rest which is
> installed there, without
> any framework upgrade.
>
> Most users are currently using the drivers from mcentral.de since it's
> more stable and very
> well tested over the last 3 years. It was basically your decision to
> not merge it back then
> http://mcentral.de/v4l-dvb/
>
> I pulled out the source and moved it together then and worked on
> additional device support.
>
> http://mcentral.de/hg/~mrec/em28xx-new/shortlog
> There are more than 200 changesets pointing out how it evolved, if
> someone wants to have an indepth
> view about it. Bugreports and patches have been posted to the em28xx
> mailinglist where people worked
> on it, including enduser applications.
>
> The xc3028 as it is in the kernel is based on leaked and partly
> reverse engineered information.
> I know that because I was also CC'ed with the leaked driver information.
>
> The Xceive drivers which I submitted are the latest versions from
> Xceive addressing several bugs,
> you might not have access to their changelog.
>
> Before continuing any discussion the sourcecode and every statement I
> made for those patchsets
> should be commented, otherwise a discussion won't go anywhere.
>

*to avoid any misunderstanding here, this is not about using
chipdrivers from userspace*

> br,
> Markus
>
