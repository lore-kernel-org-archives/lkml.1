Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbXJPOzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbXJPOzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933353AbXJPOzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:55:05 -0400
Received: from ns.suse.de ([195.135.220.2]:37331 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933803AbXJPOzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:55:03 -0400
Date: Tue, 16 Oct 2007 07:59:05 -0700
From: Greg KH <gregkh@suse.de>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, Willy Tarreau <w@1wt.eu>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Message-ID: <20071016145905.GA11214@suse.de>
References: <1192383445.8372.18.camel@dell1.softservecom.com> <20071014182542.GA2832@1wt.eu> <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com> <20071015103033.65b47dea.zaitcev@redhat.com> <1192542533.29039.58.camel@dell1.softservecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192542533.29039.58.camel@dell1.softservecom.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 04:48:54PM +0300, Vitaliy Ivanov wrote:
> Pete,
> 
> On Mon, 2007-10-15 at 20:30, Pete Zaitcev wrote:
> 
> > > +	in_end_size = le16_to_cpu(dev->interrupt_in_endpoint->wMaxPacketSize);
> > > +	out_end_size = le16_to_cpu(dev->interrupt_out_endpoint->wMaxPacketSize);
> > 
> > Did you verify if this works? We use pre-swapped descriptors in 2.4.
> > I suspect you allocate 256 times more memory than necessary.
> 
> Just checked. Seems to be OK. At least printk shows shows it.

That's probably because you tested this on a little-endian machine :)

Pete is right, this code is incorrect for 2.4, drop the le16_to_cpu
function, the wMaxPacketSize variable is in native-endian form in 2.4
and early 2.6 versions.

thanks,

greg k-h
