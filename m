Return-Path: <linux-kernel-owner+w=401wt.eu-S934653AbZHEQxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934653AbZHEQxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934487AbZHEQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:53:13 -0400
Received: from kroah.org ([198.145.64.141]:58854 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934465AbZHEQxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:53:12 -0400
Date: Wed, 5 Aug 2009 09:49:19 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 1/2] chrdev: implement __[un]register_chrdev()
Message-ID: <20090805164919.GA27457@kroah.com>
References: <4A79283E.7030202@kernel.org>
 <20090805161643.GA28436@kroah.com>
 <4A79B3A6.7090109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A79B3A6.7090109@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 01:30:30AM +0900, Tejun Heo wrote:
> Greg KH wrote:
> > On Wed, Aug 05, 2009 at 03:35:42PM +0900, Tejun Heo wrote:
> >> [un]register_chrdev() assume minor range 0-255.  This patch adds __
> >> prefixed versions which take @minorbase and @count explicitly.
> > 
> > What's the difference between this and the existing
> > register_chrdev_region() function?  Why doesn't that work for you?
> > 
> > What am I missing here?
> 
> The function names in char_dev.c are quite confusing.

That's an understatement :)


> register_chrdev_region() only registers chrdev region.
> register_chrdev() registers chrdev region and creates a cdev for the
> region.  :-)

Yes, but you can use register_chrdev_region() and then call cdev_alloc()
for the specific cdevs you need, right?  It's not the prettiest, but it
should work.

thanks,

greg k-h
