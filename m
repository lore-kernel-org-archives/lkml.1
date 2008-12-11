Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYLKBar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYLKBar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYLKBaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:30:39 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54082 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYLKBai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:30:38 -0500
Date: Wed, 10 Dec 2008 20:28:34 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Greg KH <greg@kroah.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] ibmphp: Fix module ref count underflow
Message-ID: <20081211012834.GA3262@localhost.localdomain>
References: <20081210194334.GA25257@hmsreliant.think-freely.org> <20081210222812.GA1513@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210222812.GA1513@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 02:28:12PM -0800, Greg KH wrote:
> On Wed, Dec 10, 2008 at 02:43:34PM -0500, Neil Horman wrote:
> > Hey-
> > 	I happened to notice that the ibmphp hotplug driver does something
> > rather silly in its init routine.  It purposely calls module_put so as to
> > underflow its module ref count to avoid being removed from the kernel.  This is
> > bad practice, and wrong, since it provides a window for subsequent module_gets
> > to reset the refcount to zero, allowing an unload to race in and cause all sorts
> > of mysterious panics.  If the module is unsafe to load, it should inform the
> > kernel as such with a call to __unsafe.  The patch below does that.
> > 
> > Regards
> > Neil
> > 
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> Jesse is the PCI maintainer now, you should send this to him to verify
> that it goes in.
> 
> Feel free to add my:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> to this, nice job.
> 
Thanks!  I've forwarded the patch on to Jesse.

Best
Neil

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
