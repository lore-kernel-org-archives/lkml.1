Return-Path: <linux-kernel-owner+w=401wt.eu-S965707AbXAYIZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965707AbXAYIZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 03:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965703AbXAYIZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 03:25:58 -0500
Received: from mail.kroah.org ([69.55.234.183]:48889 "EHLO perch.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965707AbXAYIZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 03:25:57 -0500
Date: Thu, 25 Jan 2007 00:25:44 -0800
From: Greg KH <greg@kroah.com>
To: Markku Savela <msa@moth.iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to get /dev entry created automaticly for dynamic major number?
Message-ID: <20070125082544.GA16300@kroah.com>
References: <200701250735.l0P7Z7aN018630@moth.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701250735.l0P7Z7aN018630@moth.iki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 09:35:07AM +0200, Markku Savela wrote:
> 
> If want to write a loadable module which "implements" a char device
> ("virtual", no real device present). How do I get the correct
> "/dev/foo" to appear automaticly?  What is the current recommended
> solution (kernel 2.6.17 in Ubuntu and later).
> 
> static int major;
> 
> static int __init foo_init(void)
>     {
>     ...
>     major = register_chrdev(0, "foo", &fops);
>     ....
>     }
> 
> static void __exit foo_exit(void)
>     {
>     ...
>     if (major > 0)
>         unregister_chrdev(major, "foo");
>     ...
>     }
> 
> I thought that the above code would be enough to trigger the "udevd",
> but apparently not (if it should, what is the match rule I have to
> use? DRIVER=="foo" or KERNEL="foo[0-9]*"? None of these seem to
> work). Do I have to do some additional poking with sysfs?  I can see
> my module there, but nothing else.
> 
> The problem seems to be that most information I find from books or net
> is out of date for 2.6, or carries note "these things are currently
> been changed". A pointer to a definitive documentation would also do!

If you look in the book, Linux Device Drivers, third edition, free
online, there's a section on what is needed for udev to work properly.

The ideas are still the same, but the way to do it has changed since the
book was written.  Just use a struct device and a class, and you will be
fine.  Look at the misc device core or the mem code in
drivers/char/mem.c for examples of what you need to do.

Hope this helps,

greg k-h
