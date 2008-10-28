Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbYJ1A1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbYJ1A1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 20:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYJ1A1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 20:27:12 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43147 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751099AbYJ1A1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 20:27:11 -0400
X-Sasl-enc: 7bKW1D+KnPi/af7bhk6F2oSZpHq0TWo8vYJpCxsRwQ7T 1225153629
Subject: Re: [PATCH 2/6] autofs4 - remove string terminator check
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       autofs@linux.kernel.org
In-Reply-To: <20081027133131.f2011d28.akpm@linux-foundation.org>
References: <20081023023513.4508.54940.stgit@raven.themaw.net>
	 <20081023023522.4508.27987.stgit@raven.themaw.net>
	 <20081027133131.f2011d28.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 09:27:02 +0900
Message-Id: <1225153622.2938.1.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 13:31 -0700, Andrew Morton wrote:
> On Thu, 23 Oct 2008 10:35:22 +0800
> Ian Kent <raven@themaw.net> wrote:
> 
> > Remove unnecessary string terminator check.
> 
> Why is it unnecessary?
> 
> Does this change alter behaviour in any way?
> 
> Does it fix a bug?

Umm .... it was done in response to your comment, quoted below ...

> +/*
> + * Check a string doesn't overrun the chunk of
> + * memory we copied from user land.
> + */
> +static int invalid_str(char *str, void *end)
> +{
> +     while ((void *) str <= end)
> +             if (!*str++)
> +                     return 0;
> +     return -EINVAL;
> +}

What is this?  We copy strings in from userspace in 10000 different
places without needing checks such as this?

> 
> Better changelogs, please....
> 
> > --- a/fs/autofs4/dev-ioctl.c
> > +++ b/fs/autofs4/dev-ioctl.c
> > @@ -51,18 +51,6 @@ static int check_name(const char *name)
> >  }
> >  
> >  /*
> > - * Check a string doesn't overrun the chunk of
> > - * memory we copied from user land.
> > - */
> > -static int invalid_str(char *str, void *end)
> > -{
> > -	while ((void *) str <= end)
> > -		if (!*str++)
> > -			return 0;
> > -	return -EINVAL;
> > -}
> > -
> > -/*
> >   * Check that the user compiled against correct version of autofs
> >   * misc device code.
> >   *
> > @@ -143,14 +131,6 @@ static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
> >  				    cmd);
> >  			goto out;
> >  		}
> > -
> > -		err = invalid_str(param->path,
> > -				 (void *) ((size_t) param + param->size));
> > -		if (err) {
> > -			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
> > -				    cmd);
> > -			goto out;
> > -		}
> >  	}
> >  
> >  	err = 0;

