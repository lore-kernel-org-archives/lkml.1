Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbYENBeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbYENBeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYENBeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:34:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:7604 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYENBeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:34:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bHoAmFvFRtaTlK5dk+rEJTnvEz+OBxqP08qSDHyLkLrcbKxJ/UTU+knO6OUxK1I72VsQDuPNL8dxP9FmaXOZh5AhZaSPxOvs0mzxdYntFWCl3bDCjQbww31XzB8FXtlrOABMVZfdb+1bQLYBeN83B+Vw/qU3nJdw8OFZk1q/h6I=
Message-ID: <a8e1da0805131834g759523bfw396b0daa532252f9@mail.gmail.com>
Date: Wed, 14 May 2008 09:34:13 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 2/3] struct class sem to mutex converting
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080513220103.GA7599@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080509072231.GB2740@darkstar.te-china.tietoenator.com>
	 <20080513220103.GA7599@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 6:01 AM, Greg KH <greg@kroah.com> wrote:
> On Fri, May 09, 2008 at 03:22:31PM +0800, Dave Young wrote:
>  > The class_device is already removed, so do the class->sem to mutex converting.
>
>  Are you sure this will work?  Have you tried running lockdep to verify
>  that there are no problems here?  People have tried this in the past
>  with devices and I don't think it will work here either :(

Yes, lockdep doesn't generate warnings on my side.

I ever wanted to do the conversion, please see:
http://lkml.org/lkml/2008/1/12/49

The result is that device sem2mutex is not possible now, but class
sem2mutex is possible.  After the class_device removing, all the
class->sem usage exist in class.c except for i2c part.

So I make i2c to use class_for_each_device api, so we can do the
class->sem conversion.

>
>  thanks,
>
>  greg k-h
>
