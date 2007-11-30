Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbXK3FHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbXK3FHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 00:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbXK3FHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 00:07:38 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:36406 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750726AbXK3FHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 00:07:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UVa3V2RxX7ppyrIzSQ5PsZxI2330pLsYoiUgEMooXOtKrdEn7KJfHo3XGvqoTvOu5Qj+djdPAOuR9rcpUD/BR2pORaG7EK9zWpQ/yL0Dlz/S6XvnzbFLKUzc98B9bo0TyAGtJYeAIqL6/H3SBwUrDxIUnuUDy7xBYWc+WlgJKh0=
Message-ID: <a8e1da0711292107q4e2e0282o2d37798dc529288c@mail.gmail.com>
Date: Fri, 30 Nov 2007 13:07:37 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [RFC] Sample kset/ktype/kobject implementation
Cc: "Greg KH" <greg@kroah.com>, "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       linux-kernel@vger.kernel.org, "Kay Sievers" <kay.sievers@vrfy.org>,
       "Jonathan Corbet" <corbet@lwn.net>,
       "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.44L0.0711291708080.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071129203900.GA27877@kroah.com>
	 <Pine.LNX.4.44L0.0711291708080.5666-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30, 2007 6:11 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 29 Nov 2007, Greg KH wrote:
>
> > > > > kobject_put(foo) is needed since it gets you through kobject_cleanup()
> > > > > where the name can be freed.
> > > >
> > > > No, kobject_register() should have handled that for us, right?
> > >
> > > kobject_register() doesn't do a kobject_put() if kobject_add() failed.
> >
> > Crap.  If I can't get this code right in an example, the API is messed
> > up.  Time to take Kay seriously and start to revamp the basic kobject
> > api :)
>
> The rule is simple enough.  After calling kobject_register() you should
> always use kobject_put() -- even if kobject_register() failed.
>
> In fact, after calling kobject_init() you should use kobject_put().
> The first rule follows from this one, since kobject_register() calls
> kobject_init() internally.
>
Hi,
The behavior is not very clear here, the root problem is that :

1. Should we call kobject_put so cleanup work can be done by refcount
touch zero or call kfree every time after kobject_register failed?

2. If kobject_put calling is true, should this be done in
kobject_register error handling codes or by hand after
kobject_register failed?

Regards
dave
> Alan Stern
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
