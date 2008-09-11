Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbYIKNAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbYIKNAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 09:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbYIKNAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 09:00:04 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:40058 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYIKNAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 09:00:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KhiSCWwqKAHsFPaD3Gwtz4S00ObQSFiwlE7EO0EMUhdstVak4doP8jQk01iv0UWFfE
         DziiAqaPmnm4CUwM4w/Qc9Ufgm5okqbKz78UxG5gJdq+1Uvc1WoxIavyz8aVsZGyKjtm
         sDpTfhMUtyiSYuXkzUHOzrsXnvUA024UAVtyc=
Date: Thu, 11 Sep 2008 08:59:57 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: touchpad driver (take 2)
Message-ID: <20080911085753.ZZRA012@mailhub.coreip.homeip.net>
References: <20080813152459.4d6bb0cb@ephemeral> <20080815031435.GD9438@anvil.corenet.prv> <20080910175513.17d900bc@dev.queued.net> <20080911010124.79166d64@dev.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080911010124.79166d64@dev.queued.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Thu, Sep 11, 2008 at 01:01:24AM -0400, Andres Salomon wrote:
> @@ -114,7 +115,7 @@ ssize_t psmouse_attr_show_helper(struct device *dev, struct device_attribute *at
>  ssize_t psmouse_attr_set_helper(struct device *dev, struct device_attribute *attr,
>  				const char *buf, size_t count);
>  
> -#define PSMOUSE_DEFINE_ATTR(_name, _mode, _data, _show, _set)			\
> +#define PSMOUSE_DEFINE_ATTR(_name, _mode, _data, _protected_set, _show, _set)	\
>  static ssize_t _show(struct psmouse *, void *data, char *);			\
>  static ssize_t _set(struct psmouse *, void *data, const char *, size_t);	\
>  static struct psmouse_attribute psmouse_attr_##_name = {			\
> @@ -129,6 +130,7 @@ static struct psmouse_attribute psmouse_attr_##_name = {			\
>  	.data	= _data,							\
>  	.show	= _show,							\
>  	.set	= _set,								\
> +	.protected_set = _protected_set,					\
>  }
>  

I would rather you defined __PSMOUSE_DEFINE_ATTR() with 'protected'
argument and then defined PSMOUSE_DEFINE_ATTR() through underscored
version so that nothing else need to be changed.

-- 
Dmitry
