Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751183AbYLQSSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbYLQSSD (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 13:18:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYLQSRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 13:17:50 -0500
Received: from kroah.org ([198.145.64.141]:52451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750875AbYLQSRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 13:17:49 -0500
Date: Wed, 17 Dec 2008 10:16:45 -0800
From: Greg KH <greg@kroah.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, v4l <video4linux-list@redhat.com>,
        Laurent Pinchart <laurent.pinchart@skynet.be>
Subject: Re: [BUG] cdev_put() race condition
Message-ID: <20081217181645.GA26161@kroah.com>
References: <200812082156.26522.hverkuil@xs4all.nl> <200812170023.41936.hverkuil@xs4all.nl> <20081216233039.GA20338@kroah.com> <200812171437.33695.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812171437.33695.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 02:37:33PM +0100, Hans Verkuil wrote:
> > Again, don't use cdev's reference counting for your own object
> > lifecycle, it is different and will cause problems, like you have found
> > out.
> 
> Sigh. It has nothing to do with how v4l uses it. And to demonstrate this, 
> here is how you reproduce it with the sg module (tested it with my USB 
> harddisk).
> 
> 1) apply this patch to char_dev.c:

<snip>

Ok, since I can't convince you that using a cdev for your reference
counting is incorrect, I'll have to go change the cdev code to prevent
you from doing this :(

Anyway, do you have a patch for the cdev code to propose how to fix this
issue you are having?

thanks,

greg k-h
