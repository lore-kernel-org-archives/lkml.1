Return-Path: <linux-kernel-owner+w=401wt.eu-S1756034AbZG2U34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbZG2U34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755826AbZG2U3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:29:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48860 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326AbZG2U3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:29:54 -0400
Date: Wed, 29 Jul 2009 13:28:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fbcon: rotate upside down crash
Message-Id: <20090729132840.2a13a04e.akpm@linux-foundation.org>
In-Reply-To: <1248768118.2992.12.camel@wall-e>
References: <1248768118.2992.12.camel@wall-e>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(let's cc linux-fbdev-devel)

On Tue, 28 Jul 2009 10:01:58 +0200
Stefani Seibold <stefani@seibold.net> wrote:

> Attached is a bug fix for the frame console. 
> 
> The current frame buffer console upside down functionality will crash
> using a font which has not a width of multiple by 8. 
> 
> The following 1 liner will fix the rotate_ud() function,
> 
> ChangeLog:
>  Fix the rotate_ud() function not to crash in case of a font which has not a width of multiple by 8: The 
>  inner loop of the font pixel copy should not access a bit outside the font memory area. Subtract the shift
>  offset from the font width will prevent this.
> 
>  fbcon_rotate.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Signed-off-by: Stefani Seibold <stefani@seibold.net>
> 
> --- linux-2.6.31-rc4.orig/drivers/video/console/fbcon_rotate.h	2009-06-10 05:05:27.000000000 +0200
> +++ linux-2.6.31-rc4/drivers/video/console/fbcon_rotate.h	2009-07-24 20:37:31.000000000 +0200
> @@ -45,7 +45,7 @@
>  	width = (width + 7) & ~7;
>  
>  	for (i = 0; i < height; i++) {
> -		for (j = 0; j < width; j++) {
> +		for (j = 0; j < width - shift; j++) {
>  			if (pattern_test_bit(j, i, width, in))
>  				pattern_set_bit(width - (1 + j + shift),
>  						height - (1 + i),

Thanks.

It seems that the bug has been there for a very very long time.  I
wonder why - presumably nobody has tried to do an upside-down rotate
before.

So given that this code sees very little use, I guess it's pretty safe
to merge the fix into 2.6.31.

