Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbZG0XeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbZG0XeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 19:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbZG0XeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 19:34:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbZG0XeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 19:34:24 -0400
Date: Mon, 27 Jul 2009 16:33:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fbcon: rotate upside down crash
Message-Id: <20090727163340.5009ff72.akpm@linux-foundation.org>
In-Reply-To: <1248463426.30437.12.camel@wall-e>
References: <1248463426.30437.12.camel@wall-e>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(cc linux-fbdev-devel)
(un-cc adaplas - he hasn't been heard from for over a year)

On Fri, 24 Jul 2009 21:23:46 +0200
Stefani Seibold <stefani@seibold.net> wrote:

> Attached is a bug fix for the frame console. 
> 
> The current frame buffer console upside down functionality will crash
> using a font which has not a width of multiple by 8. 
> 
> The following 1 liner will fix the rotate_ud() function,
> 
>  fbcon_rotate.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.31-rc4/drivers/video/console/fbcon_rotate.h	2009-07-24
> 20:37:31.000000000 +0200
> +++ linux-2.6.31-rc4.orig/drivers/video/console/fbcon_rotate.h
> 2009-06-10 05:05:27.000000000 +0200
> @@ -45,7 +45,7 @@
>  	width = (width + 7) & ~7;
>  
>  	for (i = 0; i < height; i++) {
> -		for (j = 0; j < width - shift; j++) {
> +		for (j = 0; j < width; j++) {
>  			if (pattern_test_bit(j, i, width, in))
>  				pattern_set_bit(width - (1 + j + shift),
>  						height - (1 + i),
> 

I suspect that the patch was reversed, and that you intended this:

-		for (j = 0; j < width; j++) {
+		for (j = 0; j < width - shift; j++) {

yes?


The patch was wordwrapped too - please fix the email client.


If/when resending, please add to the changelog a bit of an explanation
about the change - what was wrong with the old code and how does the
new code fix it, thanks.

