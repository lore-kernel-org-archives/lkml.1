Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbYENP6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbYENP6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbYENP6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:58:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42377 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758AbYENP6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:58:08 -0400
Date: Wed, 14 May 2008 08:57:29 -0700
From: Greg KH <greg@kroah.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] struct class sem to mutex converting
Message-ID: <20080514155729.GC28594@kroah.com>
References: <20080509072231.GB2740@darkstar.te-china.tietoenator.com> <20080513220103.GA7599@kroah.com> <a8e1da0805131834g759523bfw396b0daa532252f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0805131834g759523bfw396b0daa532252f9@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 09:34:13AM +0800, Dave Young wrote:
> On Wed, May 14, 2008 at 6:01 AM, Greg KH <greg@kroah.com> wrote:
> > On Fri, May 09, 2008 at 03:22:31PM +0800, Dave Young wrote:
> >  > The class_device is already removed, so do the class->sem to mutex converting.
> >
> >  Are you sure this will work?  Have you tried running lockdep to verify
> >  that there are no problems here?  People have tried this in the past
> >  with devices and I don't think it will work here either :(
> 
> Yes, lockdep doesn't generate warnings on my side.

I think Andrew's recent post to linux-scsi proves this is incorrect :)

> I ever wanted to do the conversion, please see:
> http://lkml.org/lkml/2008/1/12/49
> 
> The result is that device sem2mutex is not possible now, but class
> sem2mutex is possible.  After the class_device removing, all the
> class->sem usage exist in class.c except for i2c part.
> 
> So I make i2c to use class_for_each_device api, so we can do the
> class->sem conversion.

Ah, I didn't realize that the i2c patch was required.  Let me know when
Jean takes that patch in his tree.

thanks,

greg k-h
