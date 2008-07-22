Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYGVS3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYGVS3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 14:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbYGVS3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 14:29:42 -0400
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:37415 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYGVS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 14:29:41 -0400
X-Greylist: delayed 1017 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Jul 2008 14:29:41 EDT
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 02/79] kobject: replace '/' with '!' in name
Date: Tue, 22 Jul 2008 20:12:38 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
References: <20080722051805.GA17373@suse.de> <1216703983-21448-2-git-send-email-gregkh@suse.de>
In-Reply-To: <1216703983-21448-2-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807222012.39852.ioe-lkml@rameria.de>
X-Df-Sender: 849595
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
hi Kay,

On Tuesday 22 July 2008, Greg Kroah-Hartman wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> Some (block) devices have a '/' in the name, and need special
> handling. Let's have that rule to the core, so we can remove it
> from the block class.

Yes, but why replace only one?
 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index dcade05..7444015 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -216,13 +216,19 @@ static int kobject_add_internal(struct kobject *kobj)
>  static int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
>  				  va_list vargs)
>  {
> -	/* Free the old name, if necessary. */
> -	kfree(kobj->name);
> +	const char *old_name = kobj->name;
> +	char *s;
>  
>  	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
>  	if (!kobj->name)
>  		return -ENOMEM;
>  
> +	/* ewww... some of these buggers have '/' in the name ... */
> +	s = strchr(kobj->name, '/');
> +	if (s)
> +		s[0] = '!';
> +
> +	kfree(old_name);
>  	return 0;
>  }

while (s = strchr(kobj->name, '/')) {
	s[0] = '!';
}

instead?


Best Regards

Ingo Oeser
