Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0CKD2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 22:28:15 -0500
Received: from mail.perches.com ([173.55.12.10]:1631 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab0CKD2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 22:28:12 -0500
Subject: Re: [PATCH] Staging: arlan: fixed coding style issues in
 arlan-proc.c This is a patch to the arlan-proc.c file that fixes up
 multiple coding style errors and warnings found by the checkpatch.pl tool
 Signed-off-by: Andre Silva <andre.beat@gmail.com>
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?Andr=E9?= Silva <andre.beat@gmail.com>
Cc: gregkh@suse.de, linville@tuxdriver.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1268276306-14324-1-git-send-email-andre.beat@gmail.com>
References: <1268276306-14324-1-git-send-email-andre.beat@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Mar 2010 19:28:10 -0800
Message-ID: <1268278090.1674.37.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 02:58 +0000, André Silva wrote:
> From: Andre Silva <andre.beat@gmail.com>

Hi Andre.

When you send a patch, please use a shorter subject
and add some commentary in the body of the email
that describes the changes before the patch itself.

> ---
>  drivers/staging/arlan/arlan-proc.c |  623 ++++++++++++++++++------------------
>  1 files changed, 306 insertions(+), 317 deletions(-)
> 
> diff --git a/drivers/staging/arlan/arlan-proc.c b/drivers/staging/arlan/arlan-proc.c
> index b22983e..62cd1d0 100644
> --- a/drivers/staging/arlan/arlan-proc.c
> +++ b/drivers/staging/arlan/arlan-proc.c
> @@ -9,48 +9,55 @@ 

What you did here 

From:
#define ARLAN_STR_SIZE 	0x2ff0
#define DEV_ARLAN_INFO 	1
#define DEV_ARLAN 	1

to:
#define ARLAN_STR_SIZE 0x2ff0
#define DEV_ARLAN_INFO 1
#define DEV_ARLAN 1

isn't an improvement.  A lot of code in the kernel uses:

#define NAME		value

using tabs so name is in one column, value another.

> +#define SARLG(type, var) {\
> +	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x%x\n", #var,\
> +		READSHMB(priva->card->var));\
>  	}

This macro isn't nice:

It could be better as:

#define SARLG(type, var)					\
do {								\
	pos += sprintf(arlan_drive_info + pos, "%s\t=\t0x%x\n",	\
		       #var, READSHMG(priva->card->var));	\
} while (0)

or even more simpler:

#define SARLG(type, var)					\
	pos += sprintf(arlan_drive_info + pos, "%s\t=\t0x%x\n",	\
		       #var, READSHMG(priva->card->var))	\

And this:

> +#define SARLBN(type, var, nn) {\
> +	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x", #var);\
> +	for (i = 0; i < nn; i++)\
> +		pos += sprintf(arlan_drive_info+pos, "%02x",\
> +			READSHMB(priva->card->var[i]));\
> +		pos += sprintf(arlan_drive_info+pos, "\n");\
>  	}

This change is poor as you've made it seem that the last
two sprintfs are in the loop.  Only one is.

I suggest something like:

#define SARLBN(type, var, nn)					\
do {								\
	SARLG(type, var);					\
	for (i = 0; i < nn; i++)				\
		pos += sprintf(arlan_drive_info + pos, "%02x",	\
			       READSHMB(priva->card->var[i]));	\
	pos += sprintf(arlan_drive_info+pos, "\n");		\
}

Another thing you might do is get not use pos as an int,
but instead declare it as a char * starting at arlan_drive_info
so that the macros become:

	pos += sprintf(pos, fmt, args)

cheers, Joe

