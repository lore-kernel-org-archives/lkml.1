Return-Path: <linux-kernel-owner+w=401wt.eu-S1762021AbXELAtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021AbXELAtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 20:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbXELAte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 20:49:34 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54283 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbXELAtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 20:49:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] Refine SCREEN_INFO sanity check for vgacon initialization.
References: <46444F3F.6010308@redhat.com>
Date: Fri, 11 May 2007 18:48:47 -0600
In-Reply-To: <46444F3F.6010308@redhat.com> (Gerd Hoffmann's message of "Fri,
	11 May 2007 13:10:55 +0200")
Message-ID: <m1veeyrhn4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann <kraxel@redhat.com> writes:

>   Hi,
>
> Checking video mode field only to see whenever SCREEN_INFO is
> initialized is not enougth, in some cases it is zero although
> a vga card is present.  Lets additionally check cols and lines.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Updates f82af20e1a028e16b9bb11da081fa1148d40fa6a, should go
> into 2.6.22.
>
> please apply,
>   Gerd
>
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
