Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYAPTPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYAPTPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:15:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYAPTPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:15:34 -0500
Received: from ag-out-0708.google.com ([72.14.246.251]:23566 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbYAPTPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:15:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NV0ykJOCV9FQS7Kn+VMuAeDRKHxGAtCXfwS5Onpuk1zy2hOL4VVaiCHFtyGLsLRKzzusXWHs1tUXYsAY93h2QnS8FLq4PQYAkEW8OaSa+6pSyY59QKn5vnGEfQ9qZl+BFm5P7Rqmy9i1x6NDMalu71HW+Lajfe0smR4LgzvmHdo=
Date: Wed, 16 Jan 2008 14:15:26 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: psmouse: fix input_dev leak in lifebook driver
Message-ID: <20080116141353.ZZRA012@mailhub.coreip.homeip.net>
References: <20080112151252.193d6b52@ephemeral> <20080115170323.ZZRA012@mailhub.coreip.homeip.net> <20080116125801.199224f3@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116125801.199224f3@ephemeral>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 12:58:01PM -0500, Andres Salomon wrote:
> On Tue, 15 Jan 2008 17:04:01 -0500
> Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > On Sat, Jan 12, 2008 at 03:12:52PM -0500, Andres Salomon wrote:
> > > 
> > > The lifebook driver may register a second input device, but it never
> > > unregisters it.  This fixes that.
> > > 
> > > Signed-off-by: Andres Salomon <dilinger@debian.org>
> > 
> > Applied, thank you Andres.
> >
> 
> Hi Dmitry,
>  
> There's one additional patch, I don't know if you saw it; the subject
> was "check return value of input_register_device() in hil_ptr.c's init".
> 

I have seen it but postponed for later. Right now I am trying to get though
2.6.24 material.

> 
> Also, I've found myself needing to provide my own device_attribute for
> the OLPC psmouse driver; I couldn't use PSMOUSE_DEFINE_ATTR(), as its
> set_helper callback calls psmouse_disable.
> 
> static DEVICE_ATTR(powered, S_IWUSR | S_IRUGO, hgpk_show_powered,
>                 hgpk_set_powered);
> 
> Unfortunately, in order to not be racy, hgpk_set_powered needs to
> deal with psmouse_mutex.  Which method of dealing with this would
> you prefer?  I could either make psmouse_mutex no longer static,
> provide psmouse_mutex locking functions (declared in psmouse.h), or
> put psmouse_mutex into 'struct psmouse'.  Or, if you have any other
> ideas..

Could you just send me the code? I tend to think better when I see it...

Thanks!

-- 
Dmitry
