Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbZCEGEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbZCEGEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 01:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZCEGEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 01:04:43 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:38459 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZCEGEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 01:04:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H0hNSoHm1rjo1cJyDKxWXfXfmc1rSD66lk7rxLvFLHDpAZNyV53S/Gzp+6Ol+O1Ybv
         XBE7pvvdU0x/ge1Cv4KMqNVKY/E8GiDuTtn+RpNeRS1dVF4AFvRNO58EKzuo3V6zIWLy
         8j/7m7vkjHB2cNl/RFa9FQr//sO9rfkDJAdQo=
Date: Thu, 5 Mar 2009 07:04:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] unifdef.c change "getline" to "get_line" to avoid
	C library confusion.
Message-ID: <20090305060436.GA5359@nowhere>
References: <dd18b0c30903042141k1adc0f6cj4bc286cfa29f475c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd18b0c30903042141k1adc0f6cj4bc286cfa29f475c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 09:41:09PM -0800, Justin Mattock wrote:
> From: Justin P. Mattock <justinmattock@gmail.com>
> 
> This fixes an error when compiling the kernel.
> 
>   CHK     include/linux/version.h
>   HOSTCC  scripts/unifdef
> scripts/unifdef.c:209: error: conflicting types for 'getline'
> /usr/include/stdio.h:651: note: previous declaration of 'getline' was here
> make[1]: *** [scripts/unifdef] Error 1
> make: *** [__headers] Error 2
> 
> --
> scripts/unifdef.c  |  3 +++
> 1 files changed, 3 insertions(+),0 deletions(-)
> 
> diff --git a/scripts/unifdef.c b/scripts/unifdef.c
> ---a/scripts/unifdef.c
> +++b/scripts/unifdef.c
> @@ -203,1 +203,0 @@ static void             addsym(bool, bool, char *);
> 
> 
> static void             done(void);
> static void             error(const char *);
> static int              findsym(const char *);
> static void             flushline(bool);
> -static Linetype         getline(void);
> +static Linetype         get_line(void);
> static Linetype         ifeval(const char **);
> static void             ignoreoff(void);
> static void             ignoreon(void);
> static void             keywordedit(const char *);
> 
> 
> 
> 
> @@ -509,1 +509,0 @@ process(void)
> 
> 
> {
> 	Linetype lineval;
> 
> 	for (;;) {
> 		linenum++;
> -               lineval = getline();
> +		lineval = get_line();
> 		trans_table[ifstate[depth]][lineval]();
> 		debug("process %s -> %s depth %d",
> 		    linetype_name[lineval],
> 		    ifstate_name[ifstate[depth]], depth);
> 	}
> }
> 
> 
> @@ -528,1 +528,0 @@ static Linetype
> -getline(void)
> +get_line(void)
> {
> 	const char *cp;
> 
> --
> 
> 
> keep in mind I've never created a patch before,
> (so go easy on me);


Hi,

You forgot to put your Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
:)

See Documentation/SubmittingPatches

I don't know who is the maintainer of this file.
Adding Andrew in Cc.


> regards;
> 
> -- 
> Justin P. Mattock
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

