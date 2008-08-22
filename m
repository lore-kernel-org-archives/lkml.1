Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbYHVMmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbYHVMmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYHVMl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:41:57 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42286 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753930AbYHVMl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:41:56 -0400
Date: Fri, 22 Aug 2008 15:41:53 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 01/15] kobject: Replace ALL occurrences of '/' with '!'
	instead of only the first one.
Message-ID: <20080822124153.GF16680@sci.fi>
Mail-Followup-To: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	Ingo Oeser <ioe-lkml@rameria.de>,
	Kay Sievers <kay.sievers@vrfy.org>
References: <20080821173036.GB7974@suse.de> <1219339983-9634-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1219339983-9634-1-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 10:32:49AM -0700, Greg Kroah-Hartman wrote:
> From: Ingo Oeser <ioe-lkml@rameria.de>
> 
> A recent patch from Kay Sievers <kay.sievers@vrfy.org>
> replaced the first occurrence of '/' with '!' as needed for block devices.
> 
> Now do some cheap defensive coding and replace all of them to avoid future
> issues in this area.
> 
> Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  lib/kobject.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index bd732ff..fbf0ae2 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -223,8 +223,7 @@ static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  		return -ENOMEM;
>  
>  	/* ewww... some of these buggers have '/' in the name ... */
> -	s = strchr(kobj->name, '/');
> -	if (s)
> +	while ((s = strchr(kobj->name, '/')))
>  		s[0] = '!';

That's somewhat inefficient. How about this?

s = kobj->name;
while ((s = strchr(s, '/')))
	*s++ = '!';

-- 
Ville Syrjälä
syrjala@sci.fi
http://www.sci.fi/~syrjala/
