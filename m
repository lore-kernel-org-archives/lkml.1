Return-Path: <linux-kernel-owner+w=401wt.eu-S1423162AbXBIAkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423162AbXBIAkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423178AbXBIAkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:40:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423162AbXBIAko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:40:44 -0500
Date: Thu, 8 Feb 2007 16:39:34 -0800
From: Greg KH <greg@kroah.com>
To: James Simmons <jsimmons@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: device_destroy
Message-ID: <20070209003934.GA30794@kroah.com>
References: <Pine.LNX.4.64.0702081548450.7686@pentafluge.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702081548450.7686@pentafluge.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 03:51:08PM +0000, James Simmons wrote:
> 
> While porting over a few class_devices I discovered a problem with 
> device_destroy. It uses a dev_t which several classes don't use. 
> Should all classes require a dev_t or should we just pass in the device
> itself?

As you don't have a dev_t, then you have a handle to the 'struct device'
itself, right?  Then just call device_unregister(), that's all that
device_destroy() does after it finds the device in the list of devices
associated with the class.

Does this help?

thanks,

greg k-h
