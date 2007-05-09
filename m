Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbXEILWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbXEILWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755736AbXEILWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:22:03 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41546 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbXEILWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:22:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, yhlu <yhlu.kernel@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, vgoyal@in.ibm.com,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <4634483E.9030307@goop.org>
	<m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	<86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	<m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
	<86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
	<86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
	<m1k5vji107.fsf@ebiederm.dsl.xmission.com>
	<86802c440705081500x682ee098y7d51f7bb98dbcff6@mail.gmail.com>
	<4640F4B3.30408@goop.org> <4640FB2C.2060300@zytor.com>
	<86802c440705081541v7d0773cek2c5fae1854b68bbc@mail.gmail.com>
	<46410403.4050802@zytor.com>
	<m17irivkhy.fsf@ebiederm.dsl.xmission.com>
	<46413087.2020505@zytor.com>
	<m1tzumu10k.fsf@ebiederm.dsl.xmission.com>
	<46417F0B.1080405@redhat.com>
Date: Wed, 09 May 2007 05:21:01 -0600
In-Reply-To: <46417F0B.1080405@redhat.com> (Gerd Hoffmann's message of "Wed,
	09 May 2007 09:58:03 +0200")
Message-ID: <m16472tf8i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann <kraxel@redhat.com> writes:

>   Hi,
>
>> Since the whole point is to detect the case where we don't have
>> a screen at all it makes sense to check several additional variables
>> and make certain that they are all 0.  Agreed?
>
> Like in the attached patch?

Looks good to me.

> cheers,
>   Gerd
> Refine SCREEN_INFO sanity check for vgacon initialization.
>
> Checking video mode field only to see whenever SCREEN_INFO is
> initialized is not enougth, in some cases it is zero although
> a vga card is present.  Lets additionally check cols and lines.
>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Alan <alan@lxorguk.ukuu.org.uk>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  drivers/video/console/vgacon.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> Index: vanilla-2.6.21-git11/drivers/video/console/vgacon.c
> ===================================================================
> --- vanilla-2.6.21-git11.orig/drivers/video/console/vgacon.c
> +++ vanilla-2.6.21-git11/drivers/video/console/vgacon.c
> @@ -368,9 +368,14 @@ static const char *vgacon_startup(void)
>  #endif
>  	}
>  
> +	/* SCREEN_INFO initialized? */
> +	if ((ORIG_VIDEO_MODE  == 0) &&
> +	    (ORIG_VIDEO_LINES == 0) &&
> +	    (ORIG_VIDEO_COLS  == 0))
> +		goto no_vga;
> +
>  	/* VGA16 modes are not handled by VGACON */
> - if ((ORIG_VIDEO_MODE == 0x00) || /* SCREEN_INFO not initialized */
> -	    (ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
> +	if ((ORIG_VIDEO_MODE == 0x0D) ||	/* 320x200/4 */
>  	    (ORIG_VIDEO_MODE == 0x0E) ||	/* 640x200/4 */
>  	    (ORIG_VIDEO_MODE == 0x10) ||	/* 640x350/4 */
>  	    (ORIG_VIDEO_MODE == 0x12) ||	/* 640x480/4 */
