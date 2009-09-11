Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbZIKQFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbZIKQFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754549AbZIKQFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:05:47 -0400
Received: from mga06.intel.com ([134.134.136.21]:53084 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754566AbZIKQFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:05:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,371,1249282800"; 
   d="scan'208";a="549764787"
Date: Fri, 11 Sep 2009 17:00:10 +0100
From: Alan Cox <alan@linux.intel.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
 generic guest and host communication
Message-ID: <20090911170010.34c80f2d@linux.intel.com>
In-Reply-To: <1252678386-17404-2-git-send-email-amit.shah@redhat.com>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>
	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The interface presented to guest userspace is of a simple char
> device, so it can be used like this:
> 
>     fd = open("/dev/vcon2", O_RDWR);
>     ret = read(fd, buf, 100);
>     ret = write(fd, string, strlen(string));
> 
> Each port is to be assigned a unique function, for example, the
> first 4 ports may be reserved for libvirt usage, the next 4 for
> generic streaming data and so on. This port-function mapping
> isn't finalised yet.

Unless I am missing something this looks completely bonkers

Every time we have a table of numbers for functionality it ends in
tears. We have to keep tables up to date and managed, we have to
administer the magical number to name space.

Anyway - you don't seem to need a fixed number you can use dynamic
allocation and udev.

There are at least two better ways to do this

- Using sysfs nodes so you have a proper heirarchy of names/functions
- Using a simple file system which provides a heirarchy of nodes whose
  enumeration and access is backed by calls to whatever happyvisor you
  are using.

it then self enumerates, self populates, doesn't need anyone to keep
updating magic tables of guest code and expands cleanly - yes ?

Alan
