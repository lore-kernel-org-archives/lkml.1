Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbXLDHxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbXLDHxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 02:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbXLDHxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 02:53:17 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:13555 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXLDHxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 02:53:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xbN/O8lldA8+QrXCPwJcaSxzyXAa+NiQNVRBbPK2NEMzvF/GNp3Ff2ru5E7mnqSqJ5OlQUhGYzumcqmShLJMjV+UJqBkWffHyP6VW51y7zLNpgljgKM6YCHfAlA7NAMalE4nX25WBI5dDEREUcjSWsiEJterZpmjWORkobDC2ys=
Message-ID: <a8e1da0712032353m1a705ec6ged4d503818ad8f58@mail.gmail.com>
Date: Tue, 4 Dec 2007 15:53:15 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: The use of KOBJ_NAME_LEN
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20071204074612.GA25316@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204064547.GA17094@darkstar.lan>
	 <20071204074612.GA25316@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 4, 2007 3:46 PM, Greg KH <gregkh@suse.de> wrote:
> On Tue, Dec 04, 2007 at 02:45:47PM +0800, Dave Young wrote:
> > Hi,
> > Does the KOBJ_NAME_LEN really means the limit of kobject name length? seems
> > not . And if it's true, is the KOBJ_NAME_LEN of 20 enough to use?
>
> No, not anymore, the kobject name is totally dynamic.

Eh, Why does this macro still exist? If KOBJ_NAME_LEN is really
needed, maybe it should be renamed to something else to avoid
misleading.

>
> > In the kobject_set_name, the limit is 1024. Looks like either the comment or
> > the code should be updated.
>
> Here's a patch below for the comment updating it.

Thanks
>
> I also have a patch in my -mm series that takes away the 1024 character
> limit, but for 2.6.24 we'll have to live with it :)
>
> thanks,
>
> greg k-h
>
>
> ---
>  lib/kobject.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -234,13 +234,13 @@ int kobject_register(struct kobject * ko
>
>
>  /**
> - *     kobject_set_name - Set the name of an object
> - *     @kobj:  object.
> - *     @fmt:   format string used to build the name
> + * kobject_set_name - Set the name of a kobject
> + * @kobj: kobject to name
> + * @fmt: format string used to build the name
>   *
> - *     If strlen(name) >= KOBJ_NAME_LEN, then use a dynamically allocated
> - *     string that @kobj->k_name points to. Otherwise, use the static
> - *     @kobj->name array.
> + * This sets the name of the kobject.  If you have already added the
> + * kobject to the system, you must call kobject_rename() in order to
> + * change the name of the kobject.
>   */
>  int kobject_set_name(struct kobject * kobj, const char * fmt, ...)
>  {
>
