Return-Path: <linux-kernel-owner+w=401wt.eu-S1761866AbXKHRt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761866AbXKHRt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760872AbXKHRtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:49:51 -0500
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:59868 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760776AbXKHRtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:49:50 -0500
Date: Thu, 8 Nov 2007 18:49:48 +0100 (CET)
From: Peter Osterlund <petero2@telia.com>
X-X-Sender: petero@quad.localdomain
To: Thomas Maier <balagi@justmail.de>
cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: Re: pktcdvd oops
In-Reply-To: <E1Iq3NN-00049L-8x@www16.emo.freenet-rz.de>
Message-ID: <Pine.LNX.4.64.0711081845480.5401@quad.localdomain>
References: <E1Iq3NN-00049L-8x@www16.emo.freenet-rz.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, balagi@justmail.de wrote:

> tested it too, running linux 2.6.23 in a qemu instance, and the patch 
> worked. But i would prefer to take the try_module_get() stuff into 
> pkt_setup_dev() because it is used also in the older procfs interface. 
> Can we run into the same problem here, means procfs holds no module 
> references too, like sysfs now?

The procfs interface can only be used to get some debug data out from the 
driver, not to bind the driver to a CD/DVD device, so it shouldn't be a 
problem.

The other way to bind a device is to use the pktsetup program, which is 
doing ioctl calls to the driver. In that case, user space has to open the 
device before being able to do the ioctls, and the open call will increase 
the reference count.

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
