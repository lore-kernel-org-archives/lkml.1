Return-Path: <linux-kernel-owner+w=401wt.eu-S935646AbYBHAla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935646AbYBHAla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965029AbYBHAkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:40:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:40379 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965026AbYBHAkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:40:21 -0500
Date: Thu, 7 Feb 2008 16:38:25 -0800
From: Greg KH <greg@kroah.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [-mm PATCH] sysdev_unregister() should call kobject_del()
Message-ID: <20080208003825.GB27317@kroah.com>
References: <1202428618.26309.45.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202428618.26309.45.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 03:56:58PM -0800, Badari Pulavarty wrote:
> Hi Greg,
> 
> While playing with hotplug memory remove on 2.6.24-mm1, I 
> noticed that /sysfs directory entries are not getting removed.
> 
> sysdev_unregister() used to call kobject_unregister().
> But in 2.6.24-mm1, its only dropping the ref. It should
> call kobject_del() to remove the object. Correct ?
> 
> With this change, the directories are getting removed
> correctly. Comments ?

Ick, no, this shouldn't be needed, someone else must be holding a
reference to the kobject device somewhere.  See the kobject documenation
for more info.

I'll try to see where we grab 2 references...

Have I mentioned lately that I hate the sysdev code?

ugh,

greg k-h
