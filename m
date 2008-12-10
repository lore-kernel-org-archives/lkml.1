Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYLJWeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYLJWeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751448AbYLJWel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:34:41 -0500
Received: from kroah.org ([198.145.64.141]:41290 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751382AbYLJWek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:34:40 -0500
Date: Wed, 10 Dec 2008 14:28:12 -0800
From: Greg KH <greg@kroah.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] ibmphp: Fix module ref count underflow
Message-ID: <20081210222812.GA1513@kroah.com>
References: <20081210194334.GA25257@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210194334.GA25257@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 02:43:34PM -0500, Neil Horman wrote:
> Hey-
> 	I happened to notice that the ibmphp hotplug driver does something
> rather silly in its init routine.  It purposely calls module_put so as to
> underflow its module ref count to avoid being removed from the kernel.  This is
> bad practice, and wrong, since it provides a window for subsequent module_gets
> to reset the refcount to zero, allowing an unload to race in and cause all sorts
> of mysterious panics.  If the module is unsafe to load, it should inform the
> kernel as such with a call to __unsafe.  The patch below does that.
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

Jesse is the PCI maintainer now, you should send this to him to verify
that it goes in.

Feel free to add my:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

to this, nice job.

thanks,

greg k-h
