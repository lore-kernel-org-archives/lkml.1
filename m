Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYACBB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYACBB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760430AbYACBBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:01:04 -0500
Received: from hs-out-0708.google.com ([64.233.178.240]:46946 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760267AbYACBBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:01:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OhrO2fTXxA1wyRU0O9FptMajVMFYIqf6PPQ/+btNnH61g1RMK8H0oi7ndJAtsZtAt2x8JrfZEPZyMOLfjVOOxtnXegy4bxs+5GZWeBkE4bIQr4fXNo2oYOGWVmAeGVTeiOEVS2PcyGLBEIu9rKlFlCIAuJb3rM0GxJcqlLVs0ek=
Message-ID: <a8e1da0801021700s7aab56d4gc4c68aa6db5efce@mail.gmail.com>
Date: Thu, 3 Jan 2008 09:00:58 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Cc: "Greg KH" <gregkh@suse.de>, "David Miller" <davem@davemloft.net>,
       "Greg KH" <greg@kroah.com>, peterz@infradead.org,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB list" <linux-usb@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0801021057020.4861-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080102070008.GA31343@suse.de>
	 <Pine.LNX.4.44L0.0801021057020.4861-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 3, 2008 12:08 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 1 Jan 2008, Greg KH wrote:
>
> > For most cases, yes, I agree with this, but due to the lockdep issues
> > that occur here, and the whole mess with the suspend path and locking
> > the device tree, that has been hashed out many times in the past, I am
> > interested in trying to see if there is any real reason why this is
> > absolutely necessary to convert.
> >
> > If no one has noticed any issues in this area, I think the complexity
> > that will be involved in any such conversion will strongly outweigh any
> > simplicity that might be expected.
> >
> > I'm very open to potential patches to do this, just don't ignore the
> > issues that others have run into in the past when attempting this.
>
> There are two separate things to consider here.  One is struct device
> and the other is struct class.
>
> We know that replacing semaphores with mutexes in struct device doesn't
> sit well with lockdep.  However the replacement may work perfectly
> smoothly for struct class.  It would be worthwhile for Dave Young to
> separate out just that part and try it.
>
Ok, let me try a new patch only for struct class.

Regards
dave
