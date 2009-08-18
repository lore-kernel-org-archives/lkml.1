Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbZHRPRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbZHRPRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbZHRPRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:17:00 -0400
Received: from kroah.org ([198.145.64.141]:45156 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759236AbZHRPQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:16:59 -0400
Date: Tue, 18 Aug 2009 08:14:27 -0700
From: Greg KH <greg@kroah.com>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Linux USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Purpose of parameter in sysfs binary read
Message-ID: <20090818151427.GA6295@kroah.com>
References: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 08:55:29AM -0600, Rick L. Vinyard, Jr. wrote:
> The read function pointer of the sysfs bin_attribute structure has this
> signature:
> 
> ssize_t (*read)(struct kobject *kobj, struct bin_attribute *attr,
>                         char *buf, loff_t offset, size_t size);
> 
> I've figured out the purpose of all the parameters except the loff_t
> parameter.
> 
> Obviously it's an offset of some sort, but what is the meaning of the offset?

The same as any read() call, it comes from the vfs.

> If I have binary data in a char* named bindata of size bsize, should it be
> copied into buf+offset in something like:
>   memcpy(buf+offset, bindata, bsize);
> 
> Or, is it an offset from both buf and bindata in something like:
>   memcpy(buf+offset, bindata+offset, bsize-offset);

What are you using the binary sysfs attribute for?  It should ONLY be
used as a pass-through to and from hardware, with no interpretation by
the kernel at all.

See the existing users of this interface in the kernel for examples of
how to use the offset parameter.

thanks,

greg k-h
