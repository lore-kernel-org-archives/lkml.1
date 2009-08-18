Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbZHRPQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbZHRPQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZHRPQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:16:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56377 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750925AbZHRPQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:16:49 -0400
Date: Tue, 18 Aug 2009 11:16:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
cc: Linux USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Purpose of parameter in sysfs binary read
In-Reply-To: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
Message-ID: <Pine.LNX.4.44L0.0908181114020.3484-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Rick L. Vinyard, Jr. wrote:

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

It's the same offset argument that's found in all read or write 
methods for all types of files.  It refers to the offset from the start 
of the file.

> If I have binary data in a char* named bindata of size bsize, should it be
> copied into buf+offset in something like:
>   memcpy(buf+offset, bindata, bsize);
> 
> Or, is it an offset from both buf and bindata in something like:
>   memcpy(buf+offset, bindata+offset, bsize-offset);

Neither one.  If the kernel wanted to add an offset to buf, it would 
have done so before calling the function.  The code should be more like 
this:

	memcpy(buf, bindata + offset, min(size, bsize - offset));

Alan Stern

