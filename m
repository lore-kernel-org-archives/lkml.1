Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZKTVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZKTVnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753443AbZKTVnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:43:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbZKTVnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:43:15 -0500
Subject: Re: [PATCH] enclosure: fix oops while iterating enclosure_status
 array
From: James Bottomley <James.Bottomley@suse.de>
To: Jeff Mahoney <jeffm@jeffreymahoney.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-scsi@vger.kernel.org
In-Reply-To: <4B05E183.4010301@jeffreymahoney.com>
References: <4B05E183.4010301@jeffreymahoney.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 16:43:14 -0500
Message-Id: <1258753394.2889.315.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*really* (promise) adding linux-scsi to the cc list this time.

Patch looks fine to me, though, thanks.

James

On Thu, 2009-11-19 at 19:23 -0500, Jeff Mahoney wrote:
> enclosure_status is expected to be a NULL terminated array of strings
>  but isn't actually NULL terminated. When writing an invalid value to
>  /sys/class/enclosure/.../.../status, it goes off the end of the array
>  and Oopses.
> 
>  This patch uses the array size instead.
> 
> Reported-by: Artur Wojcik <artur.wojcik@intel.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  drivers/misc/enclosure.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -412,8 +412,9 @@ static ssize_t set_component_status(stru
>  	struct enclosure_component *ecomp = to_enclosure_component(cdev);
>  	int i;
>  
> -	for (i = 0; enclosure_status[i]; i++) {
> -		if (strncmp(buf, enclosure_status[i],
> +	for (i = 0; i < ARRAY_SIZE(enclosure_status); i++) {
> +		if (enclosure_status[i] &&
> +		    strncmp(buf, enclosure_status[i],
>  			    strlen(enclosure_status[i])) == 0 &&
>  		    (buf[strlen(enclosure_status[i])] == '\n' ||
>  		     buf[strlen(enclosure_status[i])] == '\0'))



