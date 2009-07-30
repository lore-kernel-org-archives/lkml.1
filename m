Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZG3HoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZG3HoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZG3HoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:44:25 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:43959 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752539AbZG3HoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:44:24 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907300743.n6U7hnK6000821@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: remove superfluous NULL pointer checks
To: bzolnier@gmail.com (Bartlomiej Zolnierkiewicz)
Date: Thu, 30 Jul 2009 17:13:49 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       error27@gmail.com (Dan Carpenter), corbet@lwn.net, eteo@redhat.com,
       julia@diku.dk (Julia Lawall)
In-Reply-To: <200907292214.31038.bzolnier@gmail.com> from "Bartlomiej Zolnierkiewicz" at Jul 29, 2009 10:14:30 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] fujitsu-laptop: remove superfluous NULL pointer checks
> 
> This takes care of the following entries from Dan's list:
> 
> drivers/platform/x86/fujitsu-laptop.c +327 set_lcd_level(13) warning: variable derefenced before check 'fujitsu'
> drivers/platform/x86/fujitsu-laptop.c +358 set_lcd_level_alt(13) warning: variable derefenced before check 'fujitsu'

I'd rather keep the test for a non-null fujitsu in there, but obviously it's
kind of pointless doing it after the first dereference.  Since this fixup
overlaps with the one previously discussed with Julia I've taken the liberty
of consolidating these - I'll send the result to the list as a separate
email.

Regards
  jonathan

> Reported-by: Dan Carpenter <error27@gmail.com>
> Cc: corbet@lwn.net
> Cc: eteo@redhat.com
> Cc: Julia Lawall <julia@diku.dk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/platform/x86/fujitsu-laptop.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> Index: b/drivers/platform/x86/fujitsu-laptop.c
> ===================================================================
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -324,9 +324,6 @@ static int set_lcd_level(int level)
>  	if (level < 0 || level >= fujitsu->max_brightness)
>  		return -EINVAL;
>  
> -	if (!fujitsu)
> -		return -EINVAL;
> -
>  	status = acpi_get_handle(fujitsu->acpi_handle, "SBLL", &handle);
>  	if (ACPI_FAILURE(status)) {
>  		vdbg_printk(FUJLAPTOP_DBG_ERROR, "SBLL not present\n");
> @@ -355,9 +352,6 @@ static int set_lcd_level_alt(int level)
>  	if (level < 0 || level >= fujitsu->max_brightness)
>  		return -EINVAL;
>  
> -	if (!fujitsu)
> -		return -EINVAL;
> -
>  	status = acpi_get_handle(fujitsu->acpi_handle, "SBL2", &handle);
>  	if (ACPI_FAILURE(status)) {
>  		vdbg_printk(FUJLAPTOP_DBG_ERROR, "SBL2 not present\n");
