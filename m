Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbYAUBRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbYAUBRo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 20:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbYAUBRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 20:17:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:25174 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbYAUBRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 20:17:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=H9R8OIh4VqA1Jwptn4Q1r/9tOB/JzH71b+KFDfcJVA/oDOkx26TaN5ng4JzxYYDUmHCnYESeyl/01aY09CEzcwYIhFbPQBBDyG5p7FK1T9u3xk62TYpXOxOQ4RZLCgwH8Mp0AKYv0ulFwvKGQ7Ia/rAWCNzYRwQGLgXTdGil0yA=
Date: Mon, 21 Jan 2008 09:19:09 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
	class
Message-ID: <20080121011909.GA2832@darkstar.te-china.tietoenator.com>
References: <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com> <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com> <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com> <1200626323.5640.21.camel@lov.site> <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com> <20080118073836.GA1703@ff.dom.local> <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com> <20080118082327.GC1703@ff.dom.local> <a8e1da0801180107w2d5a4be2r2b30d57a0d2b85ce@mail.gmail.com> <4791C555.9050205@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4791C555.9050205@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 10:39:33AM +0100, Jarek Poplawski wrote:
> Dave Young wrote, On 01/18/2008 10:07 AM:
> 
> > On Jan 18, 2008 4:23 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> 
> >> On Fri, Jan 18, 2008 at 03:48:02PM +0800, Dave Young wrote:
> 
> ...
> 
> >>> 1) Using CLASS_NORMAL/CLASS_PARENT/CLASS_CHILD will be enough.
> >>> or
> >>> 2) Simply add SINGLE_LEVEL_NESTING in class_device_add and other
> >>> class_device functions because it is the only possible nest-lock place
> >>> as I know.
> 
> 
> Dave, after looking a bit at this it seems you could be "mostly" right
> with this 2). Maybe I've missed something (I didn't verify this yet), but
> it looks like +1 level (SINGLE_LEVEL_NESTING) could be needed in:
> class_device_add() (as you did), but probably also class_device_del() and
> class_device_destroy().

Yes, I think so too.

> 
> ...But, there seems to be "little" problem, if there is used this recursion
> with: class_intf->add()/remove() in class_device_add()/del()?! Then Kay
> is right about possibility of deeper nesting. If this path is really used,
> and any of these class_device_* functions with locking are called, then
> this patch couldn't work like this. So, there is a question: how deep
> nesting is currently used here?

Currently I couldn't find such use in kernel source. IMO, drivers would not use it like this in the future because class_device will going away soon.

> 
> Regards,
> Jarek P.
