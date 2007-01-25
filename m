Return-Path: <linux-kernel-owner+w=401wt.eu-S965686AbXAYHwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965686AbXAYHwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 02:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965685AbXAYHwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 02:52:00 -0500
Received: from burp.tkv.asdf.org ([212.16.99.49]:52133 "EHLO moth.iki.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965687AbXAYHwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 02:52:00 -0500
X-Greylist: delayed 1011 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 02:51:59 EST
Date: Thu, 25 Jan 2007 09:35:07 +0200
Message-Id: <200701250735.l0P7Z7aN018630@moth.iki.fi>
From: Markku Savela <msa@moth.iki.fi>
To: linux-kernel@vger.kernel.org
Subject: How to get /dev entry created automaticly for dynamic major number?
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If want to write a loadable module which "implements" a char device
("virtual", no real device present). How do I get the correct
"/dev/foo" to appear automaticly?  What is the current recommended
solution (kernel 2.6.17 in Ubuntu and later).

static int major;

static int __init foo_init(void)
    {
    ...
    major = register_chrdev(0, "foo", &fops);
    ....
    }

static void __exit foo_exit(void)
    {
    ...
    if (major > 0)
        unregister_chrdev(major, "foo");
    ...
    }

I thought that the above code would be enough to trigger the "udevd",
but apparently not (if it should, what is the match rule I have to
use? DRIVER=="foo" or KERNEL="foo[0-9]*"? None of these seem to
work). Do I have to do some additional poking with sysfs?  I can see
my module there, but nothing else.

The problem seems to be that most information I find from books or net
is out of date for 2.6, or carries note "these things are currently
been changed". A pointer to a definitive documentation would also do!

