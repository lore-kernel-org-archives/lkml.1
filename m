Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbXEFJf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbXEFJf4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 05:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933506AbXEFJfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 05:35:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:10235 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490AbXEFJfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 05:35:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XDm6J3SxcLb+tek1cjSJm7FkjUBbNZEQn6Ky+Wq49ncHb0SwC8s1enkaMGnvzJwIuk97gBXcqFzMqMqXfrs8LPlA6gyYEQpX9nHBGdzAGC4DNAn6MEunlBf6lvSjpYqYPEdniPpMOGwb0wxQ2ly1GWSQZ7I7e3t6ZOkYtFZ01ko=
Message-ID: <3877989d0705060235p7bb7e58j1cf3172f3971c7c5@mail.gmail.com>
Date: Sun, 6 May 2007 17:35:52 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Danny Kukawka" <dkukawka@suse.de>
Subject: Re: [PATCH] ACPI video: Don't export sysfs backlight interface if query _BCL fail
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       luming.yu@intel.com
In-Reply-To: <200704271218.07411.dkukawka@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704271218.07411.dkukawka@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ack!


On 4/27/07, Danny Kukawka <dkukawka@suse.de> wrote:
> Hi,
>
> currently the acpi video module export the backlight interface to sysfs also
> if acpi_video_device_lcd_query_levels() fails to read _BLC method (e.g.
> because the method is not available). In this case the userspace don't know
> which brightness level are supported and can't set a brightness level (echo
> return with: "write error: Invalid Argument"). This happend e.g. on a ASUS
> RF1 (correct supported by the asus-laptop module).
>
> The video module should not export the backlight interface if query _BLC fail,
> because you can't set anything from userspace and this make it useless.
>
> See also: http://bugzilla.kernel.org/show_bug.cgi?id=8375
>
> Danny
>
> From: Danny Kukawka <dkukawka@suse.de>
> Subject: ACPI video: Don't export sysfs backlight interface if query _BLC fail
>
> if qeuery _BCL fail (e.g. because the method is missing in BIOS) don't
> export the backlight interface to sysfs.
>
> Signed-off-by: Danny Kukawka <dkukawka@suse.de>
> ---
>  video.c |   78 ++++++++++++++++++++++++++++--------------------------
>  1 file changed, 41 insertions(+), 37 deletions(-)
>
> --- linux-2.6.21/drivers/acpi/video.c   2007-04-26 13:50:51.000000000 +0200
> +++ linux-2.6.21/drivers/acpi/video.c   2007-04-26 13:50:53.000000000 +0200
> @@ -531,7 +531,6 @@
