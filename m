Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYH1R5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYH1R5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYH1R5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:57:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:46004 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYH1R5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:57:22 -0400
Message-ID: <48B6E69B.1090800@kernel.org>
Date: Thu, 28 Aug 2008 19:55:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] char_dev: add cdev->release() and convert	cdev_alloc()
 to use it
References: <48B6D428.2020308@kernel.org> <20080828164741.GA17475@kroah.com> <48B6D8D0.6080506@kernel.org> <20080828173813.GC18097@kroah.com> <48B6E417.5030605@kernel.org> <20080828174807.GA18461@kroah.com>
In-Reply-To: <20080828174807.GA18461@kroah.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:56:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> The problem is not the device to talk to CUSE (/dev/cuse as in
>> /dev/fuse), for which module refcount and device refcount match fine.
>> But the whole point of CUSE is allowing CUSE clients to create arbitrary
>> character devices, so in addition to /dev/cuse which clients use to talk
>> to CUSE, CUSE hosts character devices for its clients and they come and
>> go dynamically and thus requires proper lifetime management.
> 
> That's fine, it's just like a USB device that uses a cdev, right?  Or a
> PCI device, or any other type of device that can come and go independant
> of the cdev or module lifespan.
> 
> So, you tie the cdev lifespan to the module lifespan with the
> MODULE_OWNER in the file operations.  As the cuse.ko module will own the
> cdev, it can handle that reference, and it can not be removed as long as
> userspace has the cdev open, right?
> 
> It really isn't any different from any other type of removable device
> (i.e. any type of device...)

Ah.. right, but taking cdev refcount out of the picture requires adding
'severing' operation on cdev f_ops, which certainly is doable but isn't
it just cleaner to make cdev follow the usual lifetime management rules?
 An object which is referenced counted requires ->release if it's gonna
be used in any non-simplistic way.

Thanks.

-- 
tejun
